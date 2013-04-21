clc; clear;

img_source = im2double(rgb2gray(imread('test.png')));
result_figure = figure;
% subplot(2,2,1); title('source'); imshow(img);
img = imresize(img_source, 0.5,'nearest');

if (~exist('gaussian_sigma', 'var')) ; gaussian_sigma = 0.33  ;end;
if (~exist('noise_level', 'var'))    ; noise_level    = 0     ;end;

if (~exist('lambda', 'var'))         ; lambda         = 0.5   ;end;
if (~exist('gamma','var'))           ; gamma          = 300   ;end;
if (~exist('gamma_target', 'var'))   ; gamma_target   = 10    ;end;
if (~exist('k', 'var'))              ; k              = 0.95  ;end;
if (~exist('alpha', 'var'))          ; alpha          = 0.3   ;end;
if (~exist('epsilon', 'var'))        ; epsilon        = 0.001 ;end;

gaussian_kernel = fspecial('gaussian', 3, gaussian_sigma);

img = 255 * img;
scale = 2;

warps = [0 0;1 -1;-1, 1; 1,1; -1,-1];
% get lr images from hr

imgs = cell(size(warps,1),1);
for war = 1:size(warps,1)
    shifted = shift(img,warps(war,1),warps(war,2));
    imgs{war} = shifted;
    shifted = sampleimg(shifted, 1/scale, noise_level);
    imwrite(shifted, ['out\lr_' num2str(war) '.png']);
end
lr_size = size(imgs{1});
hr_size = lr_size * scale;

%% main
X = zeros(hr_size);
for i = 1:length(imgs)
    X = X + shift(sampleimg(imgs{i}, scale, 0),-warps(i,1),-warps(i,2));
end
X = X / length(imgs);

[dx, dy] = gradient(X);
gamma = max([max(dx) max(dy)]);
cont = true;
n_step = 1;
gamma_plot = []; nor_plot = []; pnsr_plot = [];

subplot(2,2,1);
imshow(X);
% imwrite(X,'combined.png')

while cont
    upsampled = zeros(hr_size);
    for im = 1:length(imgs)
        x_lr = sampleimg(shift(X,warps(im,1),warps(im,2)), 1/scale, noise_level);
        diff_lr = x_lr - imgs{im};
        upsampled = upsampled + shift(sampleimg(diff_lr, scale, 0), warps(im,1),warps(im,2));
    end

    upsampled = X - alpha * (upsampled*noise_level + lambda * G(X, gamma) );
    nor = norm(upsampled - X);

    disp(['iteration ' num2str(n_step) ', gamma=' num2str(gamma) ',norm=' num2str(nor)]);
    if (nor < epsilon)
        gamma = max(gamma_target, k*gamma);
    end
    % plot
    subplot(2,2,2);title('current');imshow(uint8(X));
    X(X<0)=0; X(X>1)=1;
    
    gamma_plot(end + 1) = gamma; 
    nor_plot(end + 1) = nor;
    pnsr_plot(end + 1) = metrics.PSNR(img_source, X);
    x_values = 1:n_step;
    subplot(2,2,3);title('NORMA');plot(x_values, nor_plot);
    
    subplot(2,2,4);title('PSNR');plot(x_values, pnsr_plot);
    ylabel('PNSR');xlabel('iteration');
    
    figure(result_figure);
    n_step = n_step+1;

    cont = ~ (nor < epsilon && gamma == gamma_target);
    X = upsampled;
    if (nor > 500 || n_step > 50)
        disp('force exit')
        cont = false;
    end
    % if (nor > 100)
    %     error('Diverge');
    % end
end

fname = ['out/nor' num2str(nor) '_l' num2str(lambda) '_a' num2str(alpha) '.png'];
saveas(result_figure, fname, 'png')
%close(result_figure);
