clear all; clc;

% set parameters
lambda = 0.2;                   % sparsity regularization
overlap = 4;                    % the more overlap the better (patch size 5x5)
up_scale = 2;                   % scaling factor, depending on the trained dictionary
maxIter = 20;                   % if 0, do not use backprojection

directory = 'Data/Testing';
outdir = 'Results';
files = dir([directory '/test*.png'])';

% load dictionary
load('Dictionary/ulitinD_512_0.15_5.mat');

for f = files
    % read test image
    filename = f.name;
    im_l = imread(fullfile(directory, filename));

    % image super-resolution based on sparse representation
    [im_h] = ScSR(im_l, 2, Dh, Dl, lambda, overlap);
    [im_h] = backprojection(im_h, im_l, maxIter);

    % upscale the chrominance simply by "bicubic" 
    [nrow, ncol] = size(im_h);
    im_h_b = imresize(im_l, [nrow, ncol], 'bicubic');

    im_l_out = [im_l; zeros(size(im_l))];
    imwrite([im_l_out, im_h, im_h_b], fullfile(outdir, filename));
end
