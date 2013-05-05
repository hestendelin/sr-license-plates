#!/bin/bash

dir="/home/d/.latextemp"
FILE="diplom_ulitin"
cp *.bib $dir

pushd $dir
bibtex $FILE.aux
popd

pdflatex -output-directory=$dir -interaction=nonstopmode "$FILE.tex"

cp $dir/$FILE.pdf $FILE.pdf