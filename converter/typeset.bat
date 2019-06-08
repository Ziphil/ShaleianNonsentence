@echo off
ruby main.rb
cd ../out
AHFCmd -pgbar -x 3 -d main.fo -p @PDF -o document.pdf 2> error.txt