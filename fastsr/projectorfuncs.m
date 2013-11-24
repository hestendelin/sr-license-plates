classdef projectorfuncs
    methods(Static)
        function imres = projector(img_source, warp1, warp2, scale)
            shifted = shift(img_source,warp1,warp2);
        %    shifted = imfilter(shifted, gaussian_kernel);
            shifted = imresize(shifted, 1/scale, 'bilinear', 'AntiAliasing',0);    
        %    shifted = shifted + opt.noise_level*randn(size(shifted));
            imres = shifted;
            %imwrite(shifted, ['out\lr_' num2str(war) '.png']);
        end

        function imres = projectorback(img_source, warp1, warp2, scale)

        %    shifted = imfilter(shifted, gaussian_kernel);
            shifted = imresize(img_source, scale, 'bilinear', 'AntiAliasing',0);   
            shifted = shift(shifted,-warp1,-warp2);
        %    shifted = shifted + opt.noise_level*randn(size(shifted));
            imres = shifted;
            %imwrite(shifted, ['out\lr_' num2str(war) '.png']);
        end
    end    
end