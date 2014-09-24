#!/gnuplot
FILE_IN="inizio_p.ANGLE.binned.ppg"
FILE_OUT="prot_an_inizio.png"
#set terminal postscript eps enhanced colour solid rounded  "Helvetica" 25
set terminal png enhanced 15
set output FILE_OUT
set xlabel "Angle (mrad)" 
#set ylabel "dN/d{/Symbol W}" 
set ylabel "dN/dAngle"
#set xtics ('-pi' -pi,'-pi/2' -pi/2,'-pi/4' -pi/4,'0' 0,'pi/4' pi/4,'pi/2' pi/2,'pi' pi)
#set xtics ('-{/Symbol p}' -pi,'-{/Symbol p}/2' -pi/2,'-{/Symbol p}/4' -pi/4,'0' 0,'{/Symbol p}/4' pi/4,'{/Symbol p}/2' pi/2,'{/Symbol p}' pi)
set format y "10^{%L}"
#set format y "%2.0t{/Symbol \327}10^{%L}"
set xrange[0:250]
#set xrange[-pi/2:pi/2]
#set yrange[1E9:1E11]
set logscale y
#set logscale x
plot  FILE_IN u (($1+$2)*0.5):3 w histeps lt 1 lc rgb "blue" lw 3 t 'angle distribution'

