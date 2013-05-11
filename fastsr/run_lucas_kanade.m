f = ls('out/*.png');
ff = [repmat('out/',5,1) f];
lucas_kanade(ff, [5 5]);
