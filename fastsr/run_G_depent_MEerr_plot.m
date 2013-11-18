load('run_G_Depent_MEerr_test.mat', 'result')

mesh = result{1}.G_plot;
%warp_noise = result{1}.W

for i = 2:length(result)
    G = result{i}.psnr_plot;
    df = size(G,2) - size(mesh,2);
    if df > 0
        mesh = padarray(mesh, [0 df], 'post');
    elseif df < 0
        G = padarray(G, [0 -df], 'post');
    end
    mesh = [mesh; G];
    %warp_noise(i) = result{i}.W;
end

surf(mesh)
