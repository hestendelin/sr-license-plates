function [ motion ] = estimateMotion(img0, img1)
%ESTIMATEMOTION Summary of this function goes here
% Parameters
opts.BlockSize   = 8;
opts.SearchLimit = 10;

% add dimension for gv
if length(size(img0,3)) == 2
    img0 = gray2rgb(img0);
    img1 = gray2rgb(img1);
end

% Enlarge image to 200-400 px
scale = 2^ceil(log2(200/size(img0,2)));
img0 = imresize(img0,scale, 'bicubic');
img1 = imresize(img1,scale, 'bicubic');

% Motion estimation
% tic
[MVx, MVy] = Bidirectional_ME(img0, img1, opts);
% toc

motion = [ median(MVx(:),1); median(MVy(:)) ] / scale;
end

