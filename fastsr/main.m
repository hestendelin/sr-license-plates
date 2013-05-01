if (~exist('is_batch','var')) 
    close all;clc; clear;
end


result_figure = figure;
% subplot(2,2,1); title('source'); imshow(img);
%img = imresize(img_source, 0.5,'nearest');

if (~exist('gaussian_sigma', 'var')) ; gaussian_sigma = 0.4      ;end;
if (~exist('noise_level', 'var'))    ; noise_level    = 0.03         ;end;

if (~exist('lambda', 'var'))         ; lambda         = 0.2       ;end;
if (~exist('gamma','var'))           ; gamma          = 300       ;end;
if (~exist('gamma_target', 'var'))   ; gamma_target   = 10        ;end;
if (~exist('k', 'var'))              ; k              = 0.95      ;end;
if (~exist('alpha', 'var'))          ; alpha          = 0.03      ;end;
if (~exist('epsilon', 'var'))        ; epsilon        = 0.005     ;end;
if (~exist('file', 'var'))    ; file    = '../plates/norm70/003.png';end;


img_source = im2double(rgb2gray(imread(file)));
% увеличиваем границы нечетного изображения
img_source = padarray(img_source,mod(size(img_source),2),'replicate','pre');

gaussian_kernel = fspecial('gaussian', ceil(gaussian_sigma*2)*2+1, gaussian_sigma);

%img = 255 * img;
scale = 2;

warps = [1 -1;];
%warps = [0 0;1 -1;-1, 1; 1,1; -1,-1];
%warps = [0 0; 0 0; 0 0; 0 0];
% get lr images from hr

imgs = cell(size(warps,1),1);
for war = 1:size(warps,1)
    shifted = shift(img_source,warps(war,1),warps(war,2));    
    shifted = imresize(shifted, 1/scale, 'bilinear', 'AntiAliasing',0);
    shifted = imfilter(shifted, gaussian_kernel);
    shifted = shifted + noise_level*randn(size(shifted));
    imgs{war} = shifted;
    %imwrite(shifted, ['out\lr_' num2str(war) '.png']);
end
lr_size = size(imgs{1});
hr_size = lr_size * scale;

%% main
X = zeros(hr_size);
for i = 1:length(imgs)
    X = X + shift(imresize(imgs{i}, scale, 'nearest'),-warps(i,1),-warps(i,2));
end
X = X / length(imgs);
init = X;
%[a,b,c] = fileparts(file);
%
%return;

[dx, dy] = gradient(X);
gamma = max([max(dx) max(dy)]);
cont = true;
n_step = 1;
gamma_plot = []; nor_plot = []; psnr_plot = [];

subplot(2,2,1);imshow(X);title('Initial estimation');
subplot(2,2,3);imshow(img_source);title('Original HR image');
% imwrite(X,'combined.png')
%warps = [0 0;1 -0.9;-1.1, 1.1; 1,0.9; -1.1,-1];
while cont
    upsampled = zeros(hr_size);
    for im = 1:length(imgs)
        x_lr = shift(X,warps(im,1),warps(im,2));
        % ???
        x_lr = imfilter(x_lr, gaussian_kernel);
        x_lr = imresize(x_lr, 1/scale, 'bilinear', 'AntiAliasing', false);
        diff_lr = x_lr - imgs{im};
        upsampled = upsampled + shift(imresize(diff_lr, scale, 'nearest'), -warps(im,1),-warps(im,2));
    end

    upsampled = X - alpha * (upsampled*1/(noise_level +1)+ lambda * G(X, gamma) );
%    alpha = alpha*0.99;
    nor = norm(upsampled - X);

    disp(['iteration ' num2str(n_step) ', gamma=' num2str(gamma) ',norm=' num2str(nor)]);
    if (nor < epsilon)
        gamma = max(gamma_target, k*gamma);
    end
    % plot
    subplot(2,2,2);imshow(uint8(255*X));title('Current');
    X(X<0)=0; X(X>1)=1;
    
    gamma_plot(end + 1) = gamma; 
    nor_plot(end + 1) = nor;
    psnr_plot(end + 1) = PSNR(img_source, X);
    x_values = 1:n_step;
    %subplot(2,2,3);plot(x_values, nor_plot);title('NORMA');
    
    subplot(2,2,4);plot(x_values, psnr_plot);title('PSNR');
    ylabel('PNSR');xlabel('iteration');
    
    figure(result_figure);
    n_step = n_step+1;

    cont = ~ (nor < epsilon && gamma == gamma_target);
    X = upsampled;
    if (nor > 5000 || n_step > 200)
        disp('force exit')
        cont = false;
    end
    % if (nor > 100)
    %     error('Diverge');
    % end
end

if (exist('is_batch','var')) 
    fname = ['out/nor' num2str(max(psnr_plot)-min(psnr_plot)) '_l' num2str(lambda) '_a' num2str(alpha) '.png'];
    saveas(result_figure, fname, 'png')
    save([fname '.mat'])
    close(result_figure);
end

