function img = downsampleimg(image, scale, noiseLevel)
    %randn('seed', 0);
    downSampledImage = imresize(image, scale, 'nearest');
    img = downSampledImage + noiseLevel*randn(size(downSampledImage));
end
