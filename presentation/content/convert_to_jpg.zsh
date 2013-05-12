#!/bin/zsh
for i (*.(pdf|jpg|png)); convert -density 300 $i jpg/$i:r.jpg
