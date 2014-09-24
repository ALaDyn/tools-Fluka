#!/gnuplot
file1="10MeV_0.1um_elettroni.txt"
file2="10MeV_0.5um_elettroni.txt"
file3="10MeV_1um_elettroni.txt"
file4="10MeV_5um_elettroni.txt"
file5="10MeV_10um_elettroni.txt"
fileout_eps="10MeV_elettroni.eps"
fileout_png="10MeV_elettroni.png"
#set terminal postscript eps enhanced colour solid rounded "Helvetica" 25
#set output fileout_eps
set terminal png enhanced 15
set output fileout_png
set xlabel "E (KeV)" 
set xrange[1:25]
set ylabel "# particles" 
set logscale y
plot file1 u (($1+$2)*500000):5 w histeps lt 1 lc rgb "blue" lw 2 t '0.1 {/Symbol m}m',\
file2 u (($1+$2)*500000):5 w histeps lt 1 lc rgb "red" lw 2 t '0.5 {/Symbol m}m',\
file3 u (($1+$2)*500000):5 w histeps lt 1 lc rgb "dark-green" lw 2 t '1 {/Symbol m}m',\
file4 u (($1+$2)*500000):5 w histeps lt 1 lc rgb "orange" lw 2 t '5 {/Symbol m}m',\
file5 u (($1+$2)*500000):5 w histeps lt 1 lc rgb "purple" lw 2 t '10 {/Symbol m}m'
#! epstopdf file && rm file #alias fileout not working here