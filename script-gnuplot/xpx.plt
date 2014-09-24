#!/gnuplot
FILE_IN_1='Prpout06.bin_xpx'
FILE_OUT='xpx.pdf'
set terminal pdf enhanced
set output FILE_OUT
set title 'dN/(dx dpx)) (cm^{-1})'
set xlabel 'x (cm)' 
set ylabel 'px'
set palette rgbformulae 22,13,10
set logscale cb
set format cb "10^{%L}"
plot FILE_IN_1 u (($3+$4)*0.5):(($1+$2)*0.5):5 w image t ''