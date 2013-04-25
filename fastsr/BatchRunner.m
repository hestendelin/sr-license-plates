close all;clc; clear;
% run in batch

lambdas = 0.2; %0:0.1:3;
alphas = 0.03;
is_batch = 1;
psnr_sr2 = [];
psnr_init = [];

files = ls('../plates/norm100/*.png');
files = files(1:16,:);
for file = 1:size(files,1)
    file = fullfile('../plates/norm100/',files(file,:));
    for alpha = alphas
        for lambda = lambdas
            main
            psnr_sr2(end+1) = max(psnr_plot);
            psnr_init(end+1) = metrics.PSNR(init, img_source);
            clearvars '*' -except -regexp lambdas?|alphas?|is_batch|psnr.*|files?
        end
    end
end