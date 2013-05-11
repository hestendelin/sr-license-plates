directory = 'out';
files = ls(fullfile(directory, '*.mat'));
fcount = size(files,1);

warps_noise = zeros(fcount,1);
psnr = zeros(fcount,1);
for f = 1:fcount
    fname = fullfile(directory, files(f,:));
    load(fname, 'warp_noise','psnr_plot');
    
    warps_noise(f)  = warp_noise;
    psnr(f)  = max(psnr_plot)-psnr_plot(1);
end
[null,order] = sort(warps_noise);
plot(warps_noise(order),psnr(order));
xlabel('warp_noise'); ylabel('psnr');