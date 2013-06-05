clear; clc; close all;
addpath('..\SubME_1.6');
%%
directory  = '..\plates\real_raw\';
file_names = ls(fullfile(directory,'*.jpg'));
% imgcount   = size(file_names, 1);

imgs = cell(0);

for ifile = [1 5]
    fname = fullfile(directory, file_names(ifile,:));
    img = rgb2ycbcr(imread(fname));
    img = double(img(:,:,1))/255;
    % увеличиваем границы нечетного изображения
    img = padarray(img,mod(size(img),2),'replicate','pre');
    imgs{end+1} = img;
end

opt = struct;

% here run FastSuperResolution
result = FastSuperResolution(imgs, opt);
disp(result);
