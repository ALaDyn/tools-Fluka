#!/gnuplot
file_in="diag05.txt"
set terminal png enhanced
set output 'electron_energy.png'
set xlabel "time (fs)" 
set y2tics
set ylabel "E (MeV)" 
plot file_in u ($1*3.33):3 w lines lt 1 lc rgb "red" lw 3 t 'Emax' axes x1y1,\
file_in u ($1*3.33):2 w lines lt 1 lc rgb "blue" lw 3 t '<E>' axes x1y2
