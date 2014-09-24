#!/gnuplot
file1="10MeV_0.1um_protoni.txt"
file2="10MeV_0.5um_protoni.txt"
file3="10MeV_1um_protoni.txt"
file4="10MeV_5um_protoni.txt"
file5="10MeV_10um_protoni.txt"
fileout_eps="10MeV_protoni.eps"
fileout_png="10MeV_protoni.png"
#set terminal postscript eps enhanced colour solid rounded "Helvetica" 25
#set output fileout_eps
set terminal png enhanced 15
set output fileout_png
set xlabel "E (MeV)" 
set xrange[9.6:10]
set ylabel "# particles" 
set logscale y
plot file1 u (($1+$2)*500):5 w histeps lt 1 lc rgb "blue" lw 2 t '0.1 microns',\
file2 u (($1+$2)*500):5 w histeps lt 1 lc rgb "red" lw 2 t '0.5 microns',\
file3 u (($1+$2)*500):5 w histeps lt 1 lc rgb "dark-green" lw 2 t '1 micron',\
file4 u (($1+$2)*500):5 w histeps lt 1 lc rgb "orange" lw 2 t '5 microns',\
file5 u (($1+$2)*500):5 w histeps lt 1 lc rgb "purple" lw 2 t '10 microns'
#! epstopdf file && rm file #alias fileout not working here