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
images_original = cell(size(files));
images_l = cell(size(files));
for indx = 1:length(files)
    % read test image
    f = files(indx);
    filename = f.name;
    img = imread(fullfile(directory, filename));
    img = rgb2gray(img);
    images_original{indx} = img;
    img = imresize(img, 1/up_scale, 'nearest');
    noise = noise_level*randn(size(img));
    img = uint8(double(img) + noise);
    images_l{indx} = img;
end

%% load dictionary
load('Dictionary/ulitinD_512_0.15_5.mat');
psnr = [];
psnrbc = [];
for index = 1:16 %length(images_l)
    im_l = images_l{index};
    or = images_original{index};
    % image super-resolution based on sparse representation
    [im_h] = ScSR(im_l, 2, Dh, Dl, lambda, overlap);
    [im_h] = backprojection(im_h, im_l, maxIter);

   
    % upscale the chrominance simply by "bicubic" 
    [nrow, ncol] = size(im_h);
    im_h_b = imresize(im_l,  size(or), 'nearest');

    clf(result_figure);
    im_hc = im_h(1:size(or,1),1:size(or,2));
    psnr(end+1) = metrics.PSNR255(or,im_hc);
    psnrbc(end+1) = metrics.PSNR255(or,im_h_b);
    plot(1:length(psnr),[psnr;psnrbc]);
    legend('pnsr SR', 'pnsr BICUBIC');
    xlabel('номер изображения'); ylabel('PSNR dB');
    
    figure(result_figure);
    
    %im_l_out = [im_l; zeros(size(im_l))];
    %imwrite([im_l_out, im_h, im_h_b], fullfile(outdir, filename));
    im_h = uint8(im_h);
    imwrite(im_h, fullfile(outdir, num2str(index,'%03d.jpg')));
end
