img = im2double(rgb2gray(imread('test.png')));
result_figure = figure;
% subplot(2,2,1); title('source'); imshow(img);
img = sampleimg(img, 0.4, 0.1);


if (~exist('gaussian_sigma')) gaussian_sigma = 0.33;
if (~exist('noise_level'))    noise_level    = 5/255;

if (~exist('lambda'))         lambda         = 0.5;
if (~exist('gamma'))          gamma          = 300;
if (~exist('gamma_target'))   gamma_target   = 10;
if (~exist('k'))              k              = 0.95;
if (~exist('alpha'))          alpha          = 0.3;
if (~exist('epsilon'))        epsilon        = 0.001;

gaussian_kernel = fspecial('gaussian', 3, gaussian_sigma);

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
gamma_plot = []; nor_plot = []; 

subplot(2,2,1);
imshow(X);

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
    subplot(2,2,2);title('current');imshow(X);
    gamma_plot(end + 1) = gamma; nor_plot(end + 1) = nor;
    x_values = 1:n_step;
    subplot(2,2,3);title('NORMA');plot(x_values, nor_plot);
    subplot(2,2,4);title('GAMMA');plot(x_values, gamma_plot);
    figure(result_figure);
    n_step = n_step+1;

    cont = ~ (nor < epsilon && gamma == gamma_target);
    X = upsampled;
    if (nor > 100 || n_step > 100)
        disp('force exit')
        cont = false;
    end
    % if (nor > 100)
    %     error('Diverge');
    % end
end

fname = ['out/nor' num2str(nor) '_l' num2str(lambda) '_g' num2str(gamma) '_eps' num2str(epsilon) '.png']
saveas(result_figure, fname, 'png')
close(result_figure);

