filename = 'out.gif';
im = im2double(rgb2gray(imread('test.png')));
for n = 1:10
    imshow(shift(im,n/10,0),'InitialMagnification','fit')
    pause(0.05)
    drawnow
    frame = getframe(1);
    img = frame2im(frame);
    [imind,cm] = rgb2ind(img,256);
    if n == 1;
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end