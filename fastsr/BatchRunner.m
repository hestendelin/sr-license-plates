close all;clc; clear;
% run in batch

b_is_batch = 1;

b_lambdas = 0:0.05:0.4;
b_alphas = 0.03;
b_blurs   = 0.01:0.2:1.0;

b_files = ls('../plates/norm50/*.png');
b_files = b_files(2:2,:);

%comment for hide
b_hide_fig = 0;

for b_file = 1:size(b_files,1)
    for b_alpha = b_alphas
        for b_lambda = b_lambdas
            for b_blur = b_blurs
                gaussian_sigma = b_blur;
                alpha = b_alpha;
                lambda = b_lambda;
                file = fullfile('../plates/norm100/',b_files(b_file,:));
                main

                clearvars '*' -except -regexp b_.*
            end
        end
    end
end