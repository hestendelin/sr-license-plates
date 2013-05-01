
% Create figure
figure1 = figure('position',[10 100 800 500]);

% Create axes
axes1 = axes('Parent',figure1);
view(axes1,[-116.5 72]);
grid(axes1,'on');
hold(axes1,'all');

% Create surf
surf(i,'Parent',axes1,'FaceLighting','none','FaceAlpha',0.5,...
    'EdgeAlpha',0.5);

% Create plot3
plot3(y(:),x(:)-0.5,is(:),'MarkerFaceColor',[1 0 0],'Marker','o','LineStyle','none',...
    'DisplayName','xxx');

