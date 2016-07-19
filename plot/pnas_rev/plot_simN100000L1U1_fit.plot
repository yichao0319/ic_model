reset
set terminal postscript eps enhanced color 28 dl 4.0
# set terminal png enhanced 28 size 800,600
# set terminal jpeg enhanced font helvetica 28


set style line 1 lc rgb "blue"    lt 1 lw 5 pt 6 ps 3 pi -1  ## x
set style line 2 lc rgb "#4daf4a" lt 1 lw 15 pt 1 ps 1.5 pi -1  ## +
set style line 3 lc rgb "#4daf4a" dt 3 lw 5 pt 1 ps 1.5 pi -1  ## +
set style line 4 lc rgb "#e41a1c" lt 1 lw 10 pt 1 ps 1.5 pi -1  ## +
set style line 5 lc rgb "#e41a1c" dt 3 lw 5 pt 1 ps 1.5 pi -1  ## +
set style line 6 lc rgb "#ffff33" lt 1 lw 20 pt 1 ps 1.5 pi -1  ## +
set style line 7 lc rgb "#ffff33" dt 3 lw 5 pt 1 ps 1.5 pi -1  ## +
set style line 9 lc rgb "#e41a1c" lt 1 lw 1 pt 3 ps 1   pi -1  ##


data_dir = "./data/"
fig_dir  = "./figs/"


##############################################
file_name = "sim.N100000.L1.U1.exp"
fig_name  = "sim-N100000-L1-U1-exp-fit"
set output fig_dir.fig_name.".eps"

set xlabel '{/Helvetica=28 Degree}' offset character 0, 0.5, 0
set ylabel '{/Helvetica=28 Probability}' offset character 1, 0, 0

set tics font "Helvetica,24"
set xtics nomirror rotate by 0
set ytics nomirror
set format y "10^{%L}"

set xrange [1:30]
set yrange [1e-7:1]

set logscale x
set logscale y

set lmargin 6
set rmargin 2.5
set bmargin 2.8
set tmargin 0.8

set key bottom left reverse nobox vertical Left spacing 1 samplen 1.5 width -1

plot data_dir.file_name.".emp.txt" using 1:2 with points ls 1 title '{/Helvetica=28 Empirical data}', \
    data_dir.file_name.".est.txt" using 1:2 with lines ls 4 title '{/Helvetica=28 Exponential}'


##############################################
file_name = "sim.N100000.L1.U1.poisson"
fig_name  = "sim-N100000-L1-U1-poisson-fit"
set output fig_dir.fig_name.".eps"

########
set xlabel '{/Helvetica=28 Degree}' offset character 0, 0.5, 0
set ylabel '{/Helvetica=28 Probability}' offset character 1, 0, 0

set tics font "Helvetica,24"
set xtics nomirror rotate by 0
set ytics nomirror
set format y "%g"

set xrange [0:12]
set yrange [0:0.6]

unset logscale x
unset logscale y

set lmargin 6
set rmargin 2.5
set bmargin 2.8
set tmargin 0.8

set key top right reverse nobox vertical Left spacing 1 samplen 1.5 width -1

plot data_dir.file_name.".emp.txt" using 1:2 with points ls 1 title '{/Helvetica=28 Empirical data}', \
    data_dir.file_name.".est.txt" using 1:2 with lines ls 4 title '{/Helvetica=28 Poisson}'

