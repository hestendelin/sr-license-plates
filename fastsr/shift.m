%shift i dy dx with subpixel
function image = shift(image, dy, dx)
    [n, m] = size(image);
    n = n+2; m = m+2;
    sdx = dx - fix(dx);
    sdy = dy - fix(dy);
    dx = fix(dx);
    dy = fix(dy);

    image = padarray(image,[1 1]);
    [ygrid,xgrid] = ndgrid(1:n,1:m);
    % cubic is better
    F = griddedInterpolant(ygrid,xgrid,image,'linear');
    image = F(ygrid-sdx, xgrid-sdy);

    if dx > 0,
        image(dx+1:n,:) = image(1:n-dx,:);
        image(1:dx,:) = zeros(dx,m);
    elseif dx < 0,
        dx = -dx;
        image(1:n-dx,:) = image(dx+1:n,:);
        image(n-dx+1:n,:) = 0;
    end

    if dy > 0,
        image(:,dy+1:m) = image(:,1:m-dy);
        image(:,1:dy) = 0;
    elseif dy < 0,
        dy = -dy;
        image(:,1:m-dy) = image(:,dy+1:m);
        image(:,m-dy+1:m) = 0;
    end
    image = image(2:end-1,2:end-1);
end
