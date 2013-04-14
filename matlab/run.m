clc; clear ;
directory = 'plates';

img_names = dir(fullfile(directory,'*.bmp'))';

noises = 0.0 : 0.03 : 0.0;
scales = 0.3 : 0.1: 0.7;
imsize = 256;

image = [];
for i = 1:size(img_names, 2)
    img = im2double(rgb2gray(imread(fullfile(directory, img_names(i).name))));
    img = img([1:end,end,end,end,end],:);
    img = img(1:20, 1:100);
    image = [image; img];
end
imwrite(image, 'result/source.png');

for scale = scales
    for n = noises
        noised_im = downsample(image, scale, n);
        imwrite(noised_im, ['result/test_n' num2str(n) '_s' num2str(scale) '.png'])
    end
end