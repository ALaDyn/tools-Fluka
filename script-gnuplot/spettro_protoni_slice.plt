#!/gnuplot
file1="inizio.ENERGY.binned.ppg"
file2="fine.ENERGY.binned.ppg"
fileout_eps="spettri.eps"
fileout_png="spettri.png"
set terminal postscript eps enhanced colour solid rounded "Helvetica" 25
set output fileout_eps
#set terminal png enhanced 15
#set output fileout_png
set xlabel "E (MeV)" 
set xrange[0.0:80.0]
#set yrange[100:1E8]
set ylabel "dN/dE (MeV^{-1})" 
set format y "10^{%L}"
#set format y "%2.0t{/Symbol \327}10^{%L}"
set logscale y
plot file1 u (($1+$2)*0.5):3 w histeps lt 1 lc rgb "blue" lw 3 t 'initial spectrum',\
file2 u (($1+$2)*0.5):3 w histeps lt 1 lc rgb "red" lw 3 t 'final spectrum'
! epstopdf spettri.eps && rm spettri.eps