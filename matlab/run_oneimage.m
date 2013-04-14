clc; clear ;
directory = 'plates';

img_names = dir(fullfile(directory,'*.bmp'))';

noises = 0.0 : 0.03 : 0.0;
scales = 0.3 : 0.1: 0.7;

for i = 1:size(img_names, 2)
    filename = img_names(i).name;
    img = im2double(rgb2gray(imread(fullfile(directory, filename))));
    %img = img([1:end,end,end,end,end],:);
    %img = img(1:20, 1:100);

    for scale = scales
        for n = noises
            noised_im = downsample(img, scale, n);
            imwrite(noised_im, ['result_one/test' num2str(filename) '_n' num2str(n) '_s' num2str(scale) '.png'])
        end
    end
end
