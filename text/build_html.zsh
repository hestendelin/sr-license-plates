rm -rf diplom_ulitin

latex2html -html_version 3.2,latin1,unicode -antialias -white -split 0 diplom_ulitin.tex

cat diplom_ulitin/diplom_ulitin.html | perl -ne '$x=$_;$x=~s!(WIDTH|HEIGHT)="([0-9]*)"!$1 . "=" . int($2/2.7)!eg; print $x' > diplom_ulitin/index.html
