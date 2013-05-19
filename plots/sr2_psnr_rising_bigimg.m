RunSrModel(struct('file','plates/norm100/055.png','gaussian_sigma',0.1,'noise_level',0.05));

scriptdir = fileparts(mfilename('fullpath'));
matlab2tikz(fullfile(scriptdir,'sr2_psnr_rising_2.tex'),'width','5cm', ...
    'relativePngPath', '../plots/');
