im = im2double(rgb2gray(imread('test.png')));
for i = 0:0.1:10
imshow(shift(im,i,i),'InitialMagnification','fit')
pause(0.05)
end