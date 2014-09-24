#!/gnuplot
#FILE_IN="inizio_p.ENERGY.binned.ppg"
FILE_IN="fine_p.ENERGY.binned.ppg"
FILE_OUT="prot_en_fine.png"
#set terminal postscript eps enhanced colour solid rounded  "Helvetica" 25
set terminal png enhanced 15
set output FILE_OUT
set xlabel "E (MeV)" 
set ylabel "dN/dE (MeV^{-1})" 
set xrange[1:30]
#set yrange[1:1E12]
set format y "10^{%L}"
#set format y "%2.0t{/Symbol \327}10^{%L}"
set logscale y
#set logscale x
plot  FILE_IN u (($1+$2)*0.5):3 w histeps lt 1 lc rgb "blue" lw 3 t 'final spectrum'
