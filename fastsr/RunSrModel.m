function result = RunSrModel(opt)

if ~isfield(opt, 'gaussian_sigma') ; opt.gaussian_sigma = 0.0000000000001            ; end ;
if ~isfield(opt, 'noise_level')    ; opt.noise_level    = 0.0                        ; end ;
if ~isfield(opt, 'warp_noise')     ; opt.warp_noise     = 0                          ; end ;
if ~isfield(opt, 'file')           ; opt.file           = '../plates/norm70/003.png' ; end ;

if ~isfield(opt, 'warps')          ; opt.warps = [0 0; 1 -1; 0.5 1; -1 -1]; end;
opt.warps = opt.warps + opt.warp_noise .* randn(size(opt.warps));

img_source = im2double(rgb2gray(imread(opt.file)));
% увеличиваем границы нечетного изображения
img_source = padarray(img_source,mod(size(img_source),2),'replicate','pre');

% ceil(gaussian_sigma*2)*2+1
gaussian_kernel = fspecial('gaussian', 7, opt.gaussian_sigma);

%img = 255 * img;
opt.scale = 2;

% get lr images from hr
imgs = cell(size(opt.warps,1),1);
for war = 1:size(opt.warps,1)
    shifted = shift(img_source,opt.warps(war,1),opt.warps(war,2));
    shifted = imresize(shifted, 1/opt.scale, 'bilinear', 'AntiAliasing',0);
    shifted = imfilter(shifted, gaussian_kernel);
    shifted = shifted + opt.noise_level*randn(size(shifted));
    imgs{war} = shifted;
    %imwrite(shifted, ['out\lr_' num2str(war) '.png']);
end

% для модели полезно.
opt.img_source = img_source;

opt.real_warps = opt.warps;
opt = rmfield(opt,'warps');
% here run FastSuperResolution
result = FastSuperResolution(imgs, opt);

end
