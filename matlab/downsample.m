function img = downsample(image, scale, noiseLevel)
    %randn('seed', 0);
    downSampledImage = imresize(image, scale, 'bicubic');
    img = downSampledImage + noiseLevel*randn(size(downSampledImage));
end
