result = {};
for warp_noise = 0:0.01:0.5
    opt.b_hide_fig = 1;
    opt.file = '../plates/raw/005.jpg';
    opt.noise_level = 0;
    opt.warp_noise = 0.5;
    result{end+1} = RunSrModel(opt);
end
save('run_G_Depent_MEerr_test.mat', 'result')