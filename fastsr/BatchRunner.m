
% run in batch

lambdas = 0:0.2:2;
alphas = 0:0.125:0.5;


for alpha = alphas
    for lambda = lambdas
    main
        clearvars '*' -except -regexp gammas|alphas
    end
end
