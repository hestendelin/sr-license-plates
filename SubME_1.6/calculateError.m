function err = calculateError(dx,dy,i1)
    shifted = i1;
    shifted(:,:,1) = shift(shifted(:,:,1),dx,dy);
    shifted(:,:,2) = shift(shifted(:,:,2),dx,dy);
    shifted(:,:,3) = shift(shifted(:,:,3),dx,dy);
    m = estimateMotion(i1, shifted);
    err = norm(m+[dy;dx]);
end
