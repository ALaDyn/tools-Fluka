#!/gnuplot
file1="spec08_Proton_18.002.txt"
file2="spec08_Proton_28.001.txt"
file3="spec08_Proton_38.txt"
file4="spec08_Proton_48.007.txt"
file5="spec08_Proton_58.007.txt"
file6="spec08_Proton_68.006.txt"
file7="spec08_Proton_78.005.txt"
file8="spec08_Proton_80.txt"
set terminal png enhanced
set output "spettri_protoni.png"
set xlabel "E (MeV)" 
#set xrange[0:10]
#set yrange[1E0:1E8]
set ylabel "dN/dE (MeV^{-1})"
set format y "10^{%L}"
set logscale y
plot file1 u 1:2 w histeps lt 1 lc rgb "blue" lw 3 t '18.002',\
file2 u 1:2 w histeps lt 1 lc rgb "dark-green" lw 3 t '28.001',\
file3 u 1:2 w histeps lt 1 lc rgb "red" lw 3 t '38',\
file4 u 1:2 w histeps lt 1 lc rgb "cyan" lw 3 t '48.007',\
file5 u 1:2 w histeps lt 1 lc rgb "pink" lw 3 t '58.007',\
file6 u 1:2 w histeps lt 1 lc rgb "gold" lw 3 t '68.006',\
file7 u 1:2 w histeps lt 1 lc rgb "black" lw 3 t '78.005',\
file8 u 1:2 w histeps lt 1 lc rgb "orange" lw 3 t '80'
