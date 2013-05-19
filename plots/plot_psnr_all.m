load('psnr_all.mat');
close;
x = 1:length(psnr_bicubic);
title('PSNR for all')
plot(x, [psnr_sr2; psnr_bicubic; psnr_nearest;psnr_sr1]);
legend('psnr SR_2', 'psnr bicubic', 'psnr nearest', 'psnr SR_1');