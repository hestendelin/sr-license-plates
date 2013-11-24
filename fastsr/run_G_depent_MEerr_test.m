result = {};
for warp_noise = 0:0.01:0.5
    opt.b_hide_fig = 1;
    opt.file = '../plates/norm50/005.png';
    opt.noise_level = 0;
    opt.warp_noise = warp_noise;
    result{end+1} = RunSrModel(opt);
end
save('run_G_Depent_MEerr_test.mat', 'result')