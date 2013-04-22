#!/bin/bash

dir="/home/d/.latextemp"
FILE="template"

pdflatex -output-directory=$dir -interaction=nonstopmode "$FILE.tex"

cp $dir/$FILE.pdf content.pdf
