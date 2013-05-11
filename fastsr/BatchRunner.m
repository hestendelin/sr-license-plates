close all;clc; clear;
% run in batch

b_is_batch = 1;

b_lambdas = 0.2;
b_alphas  = 0.03;
b_blurs   = 0.2;
b_warp_noise = 0 : 0.00740740740740740740740740740741 : 2;

b_files = ls('../plates/norm50/*.png');
b_files = b_files(2:2,:);

%comment for show figure
b_hide_fig = 0;

for b_file = 1:size(b_files,1)
for b_alpha = b_alphas
for b_lambda = b_lambdas
for b_blur = b_blurs
for b_warp_n = b_warp_noise
    tic
    fprintf(1,'Proc: %d/%d (alpha:%.2f, lambda:%.2f, blur:%.2f, wnoise:%.2f)\n',...
        b_file, size(b_files,1), b_alpha, b_lambda, b_blur, b_warp_n);
    warp_noise = b_warp_n;
    gaussian_sigma = b_blur;
    alpha = b_alpha;
    lambda = b_lambda;
    file = fullfile('../plates/norm50/',b_files(b_file,:));
    main
    toc
    clearvars '*' -except -regexp b_.*
end
end
end
end
end