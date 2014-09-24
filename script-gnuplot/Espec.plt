#!/gnuplot
FILE_IN_1='Prpout06.bin_Espec'
FILE_OUT='Espec.pdf'
set terminal pdf enhanced
set output FILE_OUT
set xlabel 'E (MeV)' 
set ylabel 'dN/dE (MeV^{-1})'
set format y '10^{%L}'
set logscale y
plot FILE_IN_1 u (($1+$2)*0.5):3 w histeps lt 1 lc rgb 'blue' lw 3 t 'energy spectrum'
