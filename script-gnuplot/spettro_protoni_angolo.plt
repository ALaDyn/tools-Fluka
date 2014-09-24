#!/gnuplot
file1="10MeV_2um_angle_protoni.txt"
fileout_eps="10MeV_2um_angle_protoni.eps"
fileout_png="10MeV_2um_angle_protoni.png"
#set terminal postscript eps enhanced colour solid rounded "Helvetica" 25
#set output fileout_eps
set terminal png enhanced 15
set output fileout_png
set xlabel "Solid angle (sr)" 
set xrange[0:6.2832]
set ylabel "# particles" 
#set logscale y
plot file1 u (($3+$4)*0.5):5 w histeps lt 1 lc rgb "blue" lw 3 t 'protons spectrum'
#! epstopdf file && rm file #alias fileout not working here