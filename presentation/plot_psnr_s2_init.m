load('psnr_sr2init.mat');
close;
x = 1:length(psnr_sr2);
title('PSNR for all')
plot(x, [psnr_sr2; psnr_init;]);
legend('PSNR SR_2', 'PSNR init');