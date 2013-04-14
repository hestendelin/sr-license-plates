function grad = G(x, gamma)
    xg = padarray(x,[1,1],'replicate');
    xv = xg(:);
    [h,w] = size(xg);
    grad = zeros(size(x));
    %        1        2          3          4          5
    %        x(i,j)   x(i-1,j)   x(i+1,j)   x(i,j-1)   x(i,j+1)
    pattern=[0        -1         1          -h         h      ];
    func = @(x1,x2)  2 .* (x1 - x2 ).* exp(-(x1-x2).^2./gamma);
    for iw = 2:w-1
        for ih = 2:h-1
            p = xv(pattern + sub2ind(size(xg),ih, iw));
            grad(ih-1,iw-1) = sum(func(p(1),p(2:5)));
        end
    end
end
