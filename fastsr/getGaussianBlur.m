function W = getGaussianBlur(sigma,imsize)
  length = imsize(1) * imsize(2);
  a = 0; b= 0;
  syms a b;  
  curcol = 1;
  W = zeros(length);
  for y = 1:imsize(1)
    for x = 1:imsize(2)
      [r,c] = ndgrid(1:imsize(1), 1:imsize(2));
      f = sym(1/sqrt(2*pi*sigma^2) * exp(- ((x-b)^2 + (y-a)^2)/(2*sigma^2)));                 
      r = subs(f, {a,b},{r,c});
      W(:, curcol) = r(:);
      curcol = curcol + 1;
    end
  end
end
