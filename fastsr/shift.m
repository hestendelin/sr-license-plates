%shift i dy dx
function image = shift(image, dy, dx)
    [n, m] = size(image);
    if dx > 0,
        image(dx+1:n,:) = image(1:n-dx,:);
        image(1:dx,:) = zeros(dx,m);
    elseif dx < 0,
        dx = -dx;
        image(1:n-dx,:) = image(dx+1:n,:);
        image(n-dx+1:n,:) = zeros(dx,m);
    end

    if dy > 0,
        image(:,dy+1:m) = image(:,1:m-dy); 
        image(:,1:dy) = zeros(n,dy);
    elseif dy < 0,
        dy = -dy;
        image(:,1:m-dy) = image(:,dy+1:m); 
        image(:,m-dy+1:m) = zeros(n,dy);
    end
end
