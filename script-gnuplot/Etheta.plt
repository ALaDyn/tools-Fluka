#!/gnuplot
FILE_IN_1='Prpout06.bin_Etheta'
FILE_OUT='Etheta.pdf'
set terminal pdf enhanced
set output FILE_OUT
set title 'dN/(dEd{/Symbol q}) (MeV^{-1} mrad^{-1})'
set xlabel 'E (MeV)' 
set ylabel '{/Symbol q} (mrad)'
set palette rgbformulae 22,13,10
set logscale cb
set format cb "10^{%L}"
plot FILE_IN_1 u (($3+$4)*0.5):(($1+$2)*0.5):5 w image t ''