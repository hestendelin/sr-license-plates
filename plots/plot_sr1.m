
% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot([psnr_sr1',psnr_bicubic'],'Parent',axes1);
set(plot1(1),'DisplayName','Алгоритм с обучаемыми словарями');
set(plot1(2),'DisplayName','Бикубическая интерполяция');

% Create xlabel
xlabel({'Номер изображения'});

ylim(axes1,[14 28]);

% Create ylabel
ylabel({'PSNR dB'});

% Create legend
legend1 = legend(axes1,'show');


scriptdir = fileparts(mfilename('fullpath'));
matlab2tikz(fullfile(scriptdir,'plot_sr1.tex'),'width','10cm');
