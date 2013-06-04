function result = FastSuperResolution (imgs, op)
% options
if ~isfield (op, 'gaussian_sigma'); op.gaussian_sigma = 0.000000001 ; end;
if ~isfield (op, 'lambda'        ); op.lambda         = 0.2         ; end;
%if ~isfield(op, 'gamma'         ); op.gamma          = 300         ; end;
if ~isfield (op, 'gamma_target'  ); op.gamma_target   = 10          ; end;
if ~isfield (op, 'k'             ); op.k              = 0.95        ; end;
if ~isfield (op, 'alpha'         ); op.alpha          = 0.07        ; end;
if ~isfield (op, 'epsilon'       ); op.epsilon        = 0.005       ; end;
if ~isfield (op, 'scale'         ); op.scale          = 2           ; end;
if ~isfield (op, 'noise_level'   ); op.noise_level    = 0.0         ; end;

if ~isfield (op, 'b_hide_fig'    ); op.b_hide_fig     = 0           ; end;
if ~isfield (op, 'b_is_batch'    ); op.b_is_batch     = 0           ; end;

%fn = fieldnames(op);
%for i = 1:length(fn)
%    field_name = fn{1};
%    assignin('caller', field_name, op.(field_name));
%end
%end options

if op.b_is_batch
    close all;clc; clear;
end

if ~op.b_hide_fig; result_figure = figure; end;
% subplot(2,2,1); title('source'); imshow(img);
%img = imresize(img_source, 0.5,'nearest');

lr_size = size(imgs{1});
hr_size = lr_size * op.scale;

% Calculate warps
if ~isfield(op, 'warps')
    addpath('../SubME_1.6/');
    zeroimage = imresize(imgs{1}, op.scale, 'bilinear');
    warps = zeros(length(imgs),2);
    for i = 2:length(imgs)
        %warps(i,:) = -estimateMotion(zeroimage,imresize(imgs{i}, op.scale, 'bilinear'));
        warps(i,:) = warpEstimate(imgs{1},imgs{i})*op.scale;
    end
else
    warps = op.warps;
end
result.warps = warps;

% precalculate kernel
gaussian_kernel = fspecial('gaussian', 7, op.gaussian_sigma);

X = zeros(hr_size);
for i = 1:length(imgs)
    X = X + shift(imresize(imgs{i}, op.scale, 'bilinear'),-warps(i,1),-warps(i,2));
end
X = X / length(imgs);
result.init = X;

[dx, dy] = gradient(X);
op.gamma = max([max(dx) max(dy)]);
cont = true;
n_step = 1;
result.gamma_plot = []; result.nor_plot = []; result.psnr_plot = [];

if ~op.b_hide_fig
    subplot(2,2,1);imshow(X);title('Начальное приближение');
    if isfield(op,'img_source')
        subplot(2,2,3);imshow(op.img_source);title('Оригинальное изображение');
    end
end
% imwrite(X,'combined.png')
while cont
    upsampled = zeros(hr_size);
    for im = 1:length(imgs)
        x_lr = shift(X,warps(im,1),warps(im,2));
        % ???
        x_lr = imfilter(x_lr, gaussian_kernel);
        x_lr = imresize(x_lr, 1/op.scale, 'bilinear', 'AntiAliasing', false);
        diff_lr = x_lr - imgs{im};
        upsampled = upsampled + ...
            shift(imresize(diff_lr, op.scale, 'nearest'), -warps(im,1),-warps(im,2));
    end

    upsampled = X - op.alpha * (upsampled*1/(op.noise_level +1)+ op.lambda * G(X, op.gamma) );
%    op.alpha = op.alpha*0.99;
    nor = norm(upsampled - X);

    if (nor < op.epsilon)
        op.gamma = max(op.gamma_target, op.k*op.gamma);
    end

    n_step = n_step+1;

    cont = ~ (nor < op.epsilon && op.gamma == op.gamma_target);
    X = upsampled;
    if (nor > 5000 || n_step > 200)
        disp('force exit')
        cont = false;
    end
    % if (nor > 100)
    %     error('Diverge');
    % end

    % Plotting
    result.gamma_plot(end + 1) = op.gamma;
    result.nor_plot(end + 1) = nor;
    if isfield(op,'img_source')
        result.psnr_plot(end + 1) = PSNR(op.img_source, X);
    end

    if ~op.b_is_batch
        disp(['Итерация ' num2str(n_step) ', gamma=' num2str(op.gamma) ',norm=' num2str(nor)]);
    end

    if ~op.b_hide_fig
        % plot
        subplot(2,2,2);imshow(uint8(255*X));title('Результат');
        x_values = 1:(n_step-1);
        %subplot(2,2,3);plot(x_values, result.nor_plot);title('NORMA');

        if isfield(op,'img_source')
            subplot(2,2,4);plot(x_values, result.psnr_plot);title('PSNR');
            ylabel('PNSR dB');
        end
        xlabel('Итерация');
        figure(result_figure);
    end
end

X(X<0)=0; X(X>1)=1;
result.img = X;

if op.b_is_batch
    fname = ['out/nor' num2str(max(result.psnr_plot)-min(result.psnr_plot)) '_l' num2str(op.lambda) '_a' num2str(op.alpha) '.png'];
    save([fname '.mat'])
    if ~op.b_hide_fig
         saveas(result_figure, fname, 'png');
         close(result_figure);
    end
end

