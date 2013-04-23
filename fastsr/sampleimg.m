function img = sampleimg(image, scale, noiseLevel)
    %randn('seed', 0);
    downSampledImage = imresize(image, scale,'bilinear', 'Antialiasing',false);
    img = downSampledImage + noiseLevel*randn(size(downSampledImage));
end



