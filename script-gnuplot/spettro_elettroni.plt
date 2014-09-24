#!/gnuplot
file1="20MeV_electrons_h2o.txt"
fileout_eps="20MeV_electrons_h2o.eps"
fileout_png="20MeV_electrons_h2o.png"
#set terminal postscript eps enhanced colour solid rounded "Helvetica" 25
#set output fileout_eps
set terminal png enhanced 15
set output fileout_png
set xlabel "E (KeV)" 
#set xrange[1:25]
set ylabel "# particles" 
set yrange[100:10000]
set logscale y
plot file1 u (($1+$2)*500000):5 w histeps lt 1 lc rgb "blue" lw 3 t 'delta eletrons spectrum'
#! epstopdf file && rm file #alias fileout not working here