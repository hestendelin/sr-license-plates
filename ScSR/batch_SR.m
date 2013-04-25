clear all; clc;

% set parameters
lambda = 0.5;                   % sparsity regularization
overlap = 4;                    % the more overlap the better (patch size 5x5)
up_scale = 2;                   % scaling factor, depending on the trained dictionary
maxIter = 20;                   % if 0, do not use backprojection

noise_level = 0;
result_figure = figure;

directory = '../plates/raw';
outdir = 'Results';
files = dir([directory '/*.jpg']);
files = files(1);
images_original = cell(size(files));
images_l = cell(size(files));
for indx = 1:length(files)
    % read test image
    f = files(indx);
    filename = f.name;
    img = imread(fullfile(directory, filename));
    img = im2double(rgb2gray(img));
    % увеличиваем границы нечетного изображения
    img = padarray(img,mod(size(img),2),'replicate','pre');

    images_original{indx} = img;
    
    img = imresize(img, 1/up_scale, 'nearest');
    img = img + noise_level*randn(size(img));
    images_l{indx} = img;
end

%% load dictionary
load('Dictionary/ulitinD_512_0.15_5.mat');
psnr = [];
psnrbc = [];
for index = 1:length(images_l)
    im_l = images_l{index};
    or = images_original{index};
    % image super-resolution based on sparse representation
    imu255 = uint8(im_l*255);
    [im_h] = ScSR(imu255, 2, Dh, Dl, lambda, overlap);
    [im_h] = backprojection(im_h, imu255, maxIter);
    im_h = im_h/255;
    
    % upscale the chrominance simply by "bicubic" 
    [nrow, ncol] = size(im_h);
    im_h_b = imresize(im_l,  2, 'bicubic','AntiAliasing',0);

    clf(result_figure);
    % im_hc = im_h(1:size(or,1),1:size(or,2));
    psnr(end+1) = metrics.PSNR(or,im_h);
    psnrbc(end+1) = metrics.PSNR(or,im_h_b);
    plot(1:length(psnr),[psnr;psnrbc]);
    legend('pnsr SR', 'pnsr BICUBIC');
    xlabel('номер изображения'); ylabel('PSNR dB');
    
    figure(result_figure);
    
    %im_l_out = [im_l; zeros(size(im_l))];
    %imwrite([im_l_out, im_h, im_h_b], fullfile(outdir, filename));
   
    imwrite(im_h, fullfile(outdir, num2str(index,'%03d.jpg')));
end
