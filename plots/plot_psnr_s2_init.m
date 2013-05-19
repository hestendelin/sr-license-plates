load('psnr_sr2init.mat');
close;
x = 1:length(psnr_sr2);
title('PSNR for all')
plot(x, [psnr_sr2; psnr_init;]);
legend('�������� � ��������������', '��������� �����������');

% Create xlabel
xlabel({'����� �����������'});

% ylim(axes1,[14 28]);

% Create ylabel
ylabel({'PSNR dB'});

scriptdir = fileparts(mfilename('fullpath'));
matlab2tikz(fullfile(scriptdir,'plot_sr2.tex'),'width','10cm');
