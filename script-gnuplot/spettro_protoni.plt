#!/gnuplot
file1="20MeV_protons_h2o.txt"
fileout_eps="20MeV_protons_h2o.eps"
fileout_png="20MeV_protons_h2o.png"
#set terminal postscript eps enhanced colour solid rounded "Helvetica" 25
#set output fileout_eps
set terminal png enhanced 15
set output fileout_png
set xlabel "E (MeV)" 
#set xrange[19.9:20.1]
set yrange[100:1E8]
set ylabel "# particles" 
set logscale y
plot file1 u (($1+$2)*500):5 w histeps lt 1 lc rgb "blue" lw 3 t 'protons spectrum'
#! epstopdf file && rm file #alias fileout are not working here!