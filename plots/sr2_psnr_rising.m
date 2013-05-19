RunSrModel(struct('file','plates/norm50/005.png'));

scriptdir = fileparts(mfilename('fullpath'));
matlab2tikz(fullfile(scriptdir,'sr2_psnr_rising.tex'),'width','5cm', ...
    'relativePngPath', '../plots/');
