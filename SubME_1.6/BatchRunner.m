clc;
clear;


img0 = imresize((im2double(imread('../plates/norm50/001.png'))),1);
% img0 = imresize(img0,0.5);

dxs = -0.2:0.1:2;
dys = -0.2:0.1:1.2;

[gx,gy] = ndgrid(dxs, dys);
result = zeros(length(dxs),length(dys));

tic
parfor num = 1:length(result(:))
    result(num) = calculateError(gx(num),gy(num), img0);
end
toc

surf(gx,gy,result);
xlabel('shift x');
ylabel('shift y');
zlabel('Error in estimation');
