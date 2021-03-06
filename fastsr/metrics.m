% uses file ssim_index.m

classdef metrics    
    methods(Static)        
        function [result] = norm(image, p)
            if p == 1,
                result = sum(abs(image));
            elseif p >= 2
                result = sum((image(:)).^p);
            else
                throw(MException('metrics:norm', sprintf('Cannot calculate image norm for p = %d', p)));
            end
        end
        
        function [result] = points(image)
            [n, m] = size(image);
            result = n * m;
        end                            
        
        % Mean Square Error
        function [mse] = MSE(image1, image2)
            cs = 0;
            diff = image1 - image2;
            diff = diff(1+cs:end-cs, 1+cs:end-cs);
            mse = metrics.norm(diff, 2) / metrics.points(diff);
        end
        
        % Peak Signal-to-Noise Ratio
        function [psnr] = PSNR(image1, image2)
            psnr = 10*log10(1 / metrics.MSE(image1, image2));            
        end
        
        % Peak Signal-to-Noise Ratio with 255 levels images
        function [psnr] = PSNR255(image1, image2)
            psnr = 10*log10(255^2 / metrics.MSE(double(image1), double(image2)));            
        end
        
        % Improvement Signal-to-Noise Ration
        function [isnr] = ISNR(idealImage, firstImage, currentImage)
            isnr = 10*log10(metrics.norm(idealImage - firstImage, 2) / metrics.norm(idealImage - currentImage, 2));
        end
        
        % Mean Absolute Error
        function [mae] = MAE(image1, image2)
            mae = metrics.norm(image1 - image2, 1) / metrics.points(image1);
        end
        
        % Structural Similarity
        function [ssim] = SSIM(image1, image2)
            ssim = ssim_index(image1, image2, [0.01 0.03], ones(8), 1);
        end
        
        % Blured Signal-to-Noise Ratio
        % Note : noise level is equal to sigma^2
        function [bsnr] = BSNR(bluredImage, noiseLevel)
            bsnr = 10*log10(metrics.norm(bluredImage, 2)) / (metrics.points(bluredImage) * noiseLevel);
        end
    end
    
end
