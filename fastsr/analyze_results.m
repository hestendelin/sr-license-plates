directory = 'result_lambda_blur_more_warps';
files = ls(fullfile(directory, '*.mat'));
fcount = size(files,1);

lambdas = zeros(fcount,1);
blurs = zeros(fcount,1);
psnr = zeros(fcount,1);
for f = 1:fcount
    fname = fullfile(directory, files(f,:));
    load(fname, 'b_blur','b_lambda','psnr_plot');
    
    blurs(f)  = b_blur;
    lambdas(f) = b_lambda;
    psnr(f)  = max(psnr_plot)-psnr_plot(1);
end

f = TriScatteredInterp(lambdas, blurs, psnr);
[x,y] = meshgrid(unique(lambdas),unique(blurs));
surf(x,y,f(x,y));
xlabel('lambdas'); ylabel('blur'); zlabel('psnr');