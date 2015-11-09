#!/bin/perl

##########################################
## Author: Yi-Chao Chen @ UT Austin
##
## - input:
##
## - output:
##
## - e.g.
##   
##
##########################################

use strict;
use POSIX;
use List::Util qw(first max maxstr min minstr reduce shuffle sum);
use Math::Trig qw(deg2rad pi great_circle_distance);
# use lib "/u/yichao/utils/perl";
# use lib "../utils";

#############
# Debug
#############
my $DEBUG0 = 0;
my $DEBUG1 = 1;
my $DEBUG2 = 1; ## print progress
my $DEBUG3 = 0; ## print output


#############
# Constants
#############
my $input_dir  = "./raw_beijing_taxi";
my $output_dir = "./processed_beijing_taxi";
# my $filename = "bus";

#############
# Variables
#############
my %trace;
my %times;


#############
# check input
#############
if(@ARGV != 2) {
    print "wrong number of input: ".@ARGV."\n";
    exit;
}
my $itvl = $ARGV[0] + 0;
my $range = $ARGV[1] + 0;


#############
# Main starts
#############

#############
## decompress
#############
# print "Decompress\n" if($DEBUG2);

# my $cmd = "gunzip $input_dir/*gz";
# `$cmd`;


#############
## read directory
#############
my $cnt = 0;
opendir(my $dh, $input_dir) || die $!;
while(readdir $dh) {
    chomp;
    if($_ =~ /(\d+)\.txt/) {
        my $filename = $1;
        print "  $filename\n" if($DEBUG3);

        #############
        ## DEBUG
        $cnt ++;
        # last if($cnt > 5);
        #############

        #############
        ## Read Data
        #############
        # print "Read Data\n" if($DEBUG2);
        
        open FH, "$input_dir/$filename.txt" or die $!;
        while(<FH>) {
            print $_ if($DEBUG3);
            chomp;
            my @data = split(/,/, $_);
            my $timestr = $data[1];
            my $car = $data[0]+0;
            my $lat = $data[3]+0;
            my $lng = $data[2]+0;

            my $time = 0;
            if($timestr =~ /(\d+)-(\d+)-(\d+)\s+(\d+):(\d+):(\d+)/) {
                my $year = $1+0;
                my $mon = $2+0;
                my $day = $3+0;
                my $hour = $4+0;
                my $min = $5+0;
                my $sec = $6+0;

                $time = (((get_month_cumdays($mon-1) + $day)*24 + $hour)*60 + $min)*60 + $sec;
                $times{$time} = 1;
            }
            else { die "Wrong Time Format: $timestr"; }
                

            print "  car $car [$lat, $lng] at $time\n" if($DEBUG3);
            # $trace{$car}{$time}{X} = $lat;
            # $trace{$car}{$time}{Y} = $lng;
            $trace{$car}{TIME}{$time}{X} = $lat;
            $trace{$car}{TIME}{$time}{Y} = $lng;

        }
        close FH;
    }
}
closedir $dh;

# exit
# print "  #car = ".(scalar keys %trace)."\n";
# foreach my $this_car (sort {$a <=> $b} keys %trace) {
#     next if (scalar (keys %{$trace{$this_car}}) < 1000);

#     open FH, "> $output_dir/cars/$this_car.txt" or die $!;
#     foreach my $this_time (sort {$a <=> $b} keys %{$trace{$this_car}}) {
#         print FH "$this_time, ".$trace{$this_car}{$this_time}{X}.", ".$trace{$this_car}{$this_time}{Y}."\n";
#     }
#     close FH;

#     my @tmp = sort {$a <=> $b} keys %{$trace{$this_car}};
#     print "  car $this_car: #loc=".(keys %{$trace{$this_car}}).", time=".($tmp[@tmp-1] - $tmp[0])."\n";
# }
# return

# my @tmp = sort {$a <=> $b} (keys %times);
# print "  overall time = ".($tmp[@tmp-1] - $tmp[0])."\n";

# open FH, "> $output_dir/times.txt" or die $!;
# print FH join("\n", sort {$a <=> $b} (keys %times))."\n";
# close FH;


#############
## Interpolation
#############
print "Interpolation\n" if($DEBUG2);

# my @times = sort {$a <=> $b} keys %times;
my @tmp = sort {$a <=> $b} keys %times;
my $x = 0;
my @times = grep {not ++$x % $itvl } ($tmp[0] .. $tmp[-1]);

my %new_trace;

foreach my $this_car (keys %trace) {
    print "car $this_car\n";
    my $tidx = 0;
    my $pre_time = -1;
    my $prex = 0;
    my $prey = 0;

    my @old_times = sort {$a <=> $b} keys %{$trace{$this_car}{TIME}};
    foreach my $this_time (@old_times) {
        my $thisx = $trace{$this_car}{TIME}{$this_time}{X};
        my $thisy = $trace{$this_car}{TIME}{$this_time}{Y};
        # print "car$this_car: car=$this_time [$thisx,$thisy], all=".$times[$tidx]."\n";
        last if($tidx >= @times);

        while($this_time > $times[$tidx]) {
            last if($tidx >= @times);

            my $interp_time = $times[$tidx];

            my ($interpx, $interpy) = interp($pre_time, $prex, $prey, $this_time, $thisx, $thisy, $interp_time);
            $new_trace{$this_car}{TIME}{$interp_time}{X} = $interpx;
            $new_trace{$this_car}{TIME}{$interp_time}{Y} = $interpy;
            # print "  idx$tidx/".@times.": interp time=$interp_time [$interpx, $interpy]\n";
            
            $tidx ++;
            last if($tidx >= @times);
        }        
        last if($tidx >= @times);

        if($this_time == $times[$tidx]) {
            $new_trace{$this_car}{TIME}{$this_time}{X} = $thisx;
            $new_trace{$this_car}{TIME}{$this_time}{Y} = $thisy;
            $tidx ++;
            # print "  idx$tidx/".@times.": same\n";
        }

        $pre_time = $this_time;
        $prex = $thisx;
        $prey = $thisy;
    }
}


#############
## Find contact counts
#############
print "Find contact counts\n" if($DEBUG2);

my @counts;
my @cars = sort {$a <=> $b} keys %new_trace;
foreach my $this_time (@times) {
    print "  time = ".(($this_time-$times[0]) / $itvl)."/".@times."\n";
    foreach my $ci (0..@cars-1) {
        my $thisx1 = 0;
        my $thisy1 = 0;
        my $count = 0;

        if(exists $new_trace{$cars[$ci]}{TIME}{$this_time}) {
            $thisx1 = $new_trace{$cars[$ci]}{TIME}{$this_time}{X};
            $thisy1 = $new_trace{$cars[$ci]}{TIME}{$this_time}{Y};
        }
        if($thisx1 == 0 and $thisy1 == 0) {
            next;
        }

        foreach my $cj (0..@cars-1) {
            my $thisx2 = 0;
            my $thisy2 = 0;

            if(exists $new_trace{$cars[$cj]}{TIME}{$this_time}) {
                $thisx2 = $new_trace{$cars[$cj]}{TIME}{$this_time}{X};
                $thisy2 = $new_trace{$cars[$cj]}{TIME}{$this_time}{Y};
            }
            if($thisx2 == 0 and $thisy2 == 0) {
                next;
            }

            my $dist = GreatCircle($thisx1, $thisy1, $thisx2, $thisy2);
            # print "  car".$cars[$ci]."[$thisx1,$thisy1]-car".$cars[$cj]."[$thisx2,$thisy2] dist=$dist\n";
            if($dist < $range) {
                $count ++;
            }
        }

        push(@counts, $count);
    }
}


open FH, "> $output_dir/counts.$itvl.$range.txt" or die $!;
print FH join("\n", sort(@counts))."\n";
close FH;


#############
## compress
#############
# print "Compress\n" if($DEBUG2);

# my $cmd = "gzip $input_dir/Taxi* taxi.gzip";
# `$cmd`;





sub get_month_cumdays {
    my $mon = $_[0];

    if($mon == 0) {
        return 0;
    }

    my @days = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
    for my $i (1..11) {
        $days[$i] += $days[$i-1];
    }
    
    return $days[$mon-1];
}


sub GreatCircle {
    my ($lat1, $long1, $lat2, $long2) = @_;
    my $r=6367000;
    my @zip1 = (deg2rad($long1), deg2rad(90-$lat1));
    my @zip2 = (deg2rad($long2), deg2rad(90-$lat2));
    my $dist = great_circle_distance(@zip1, @zip2,$r);
                     
    return $dist;
}


sub interp {
    my ($pre_time, $prex, $prey, $this_time, $thisx, $thisy, $interp_time) = @_;

    if($pre_time < 0) {
        return (0,0);
    }

    my $ratio = ($interp_time - $pre_time) / ($this_time - $pre_time);
    my $interpx = $prex + ($thisx - $prex) * $ratio;
    my $interpy = $prey + ($thisy - $prey) * $ratio;
    return ($interpx, $interpy);
}
