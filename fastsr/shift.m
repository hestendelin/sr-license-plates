%shift i dy dx with subpixel
function image = shift(image, dy, dx)
    [n, m] = size(image);

    [ygrid,xgrid] = ndgrid(1:n,1:m);

    % cubic is better
    image = interp2(ygrid',xgrid',image',ygrid-dy, xgrid-dx,'linear',0);
end
