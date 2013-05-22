%CREATEFIGURE(YMATRIX1)
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 19-May-2013 15:55:54

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot([psnr_sr1',psnr_bicubic'],'Parent',axes1);
set(plot1(1),'DisplayName','�������� � ���������� ���������');
set(plot1(2),'DisplayName','������������ ������������');

% Create xlabel
xlabel({'����� �����������'});

ylim(axes1,[14 28]);

% Create ylabel
ylabel({'PSNR'});

% Create legend
legend1 = legend(axes1,'show');
%set(legend1,...
%    'Position',[0.159820058317985 0.80006436918201 0.289134438305709 0.0892156862745098]);
matlab2tikz('plot_sr1.tex','width','10cm')