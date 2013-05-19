close all;clc; clear;
% run in batch

lambdas = 0.2; %0:0.1:3;
alphas = 0.03;
is_batch = 1;
%psnr_sr2 = [];

psnr_bicubic = [];
psnr_nearest = [];

files = ls('plates/norm50/*.png');
files = files(1:16,:);
for file = 1:size(files,1)
    file = fullfile('plates/norm50/',files(file,:));
    for alpha = alphas
        for lambda = lambdas
            im = im2double(rgb2gray(imread(file)));
            % увеличиваем границы нечетного изображения
            im = padarray(im,mod(size(im),2),'replicate','pre');

            imsmall = imresize(im, 1/2, 'bilinear', 'AntiAliasing',0);
            imbicubic = imresize(imsmall, 2, 'bicubic', 'AntiAliasing',0);
            imnearest = imresize(imsmall, 2, 'nearest');
            psnr_bicubic(end+1) = metrics.PSNR(im, imbicubic);
            psnr_nearest(end+1) = metrics.PSNR(im, imnearest);
            
            %main
            %psnr_sr2(end+1) = max(psnr_plot);
            %clearvars '*' -except -regexp lambdas?|alphas?|is_batch|psnr_sr2|files?
        end
    end
end