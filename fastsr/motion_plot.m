img_source = im2double(rgb2gray(imread('../plates/real_raw/P5020080.JPG')));
% увеличиваем границы нечетного изображения
img_source = padarray(img_source,mod(size(img_source),2),'replicate','pre');

img = shift(img_source, -1.5, -1);
%img = im2double(rgb2gray(imread('../plates/real_raw/P5020083.JPG')));
% увеличиваем границы нечетного изображения
%img = padarray(img,mod(size(img),2),'replicate','pre');

dxs = -2:0.1:2;
dys = -2:0.1:2;
[x,y] = ndgrid(dxs, dys);
z = zeros(size(x));

for dx = 1:length(dxs)
    for dy = 1:length(dys)
        dif = img_source - shift(img, dys(dy), dxs(dx));
        z(dx,dy) = norm(dif(:));
    end
end
[c,i] = min(z(:));
disp(['X = ' num2str(x(i)) ', y='  num2str(y(i))])
surf(x,y,z);