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
my $input_dir  = "./raw_seattle_bus";
my $output_dir = "./processed_seattle_bus";
# my $filename = "bus";

#############
# Variables
#############
my %trace;
my %times;


#############
# check input
#############
if(@ARGV != 0) {
    print "wrong number of input: ".@ARGV."\n";
    exit;
}
# $ARGV[0];


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
opendir(my $dh, $input_dir) || die $!;
while(readdir $dh) {
    chomp;
    if($_ =~ /(Trace\d+)/) {
        my $filename = $1;
        print "  $filename\n" if($DEBUG3);

        #############
        ## Read Data
        #############
        # print "Read Data\n" if($DEBUG2);
        
        open FH, "$input_dir/$filename" or die $!;
        while(<FH>) {
            print $_ if($DEBUG3);
            chomp;
            my @data = split(/\s+/, $_);
            my $timestr = $data[0];
            my $car = $data[1];
            my $locx = $data[4] * 0.3048;
            my $locy = $data[5] * 0.3048;

            my $time = 0;
            if($timestr =~ /(\d+)-(\d+):(\d+):(\d+):(\d+)/) {
                my $day = $1+0;
                my $mon = $2+0;
                my $hour = $3+0;
                my $min = $4+0;
                my $sec = $5+0;

                $time = (((get_month_cumdays($mon-1) + $day)*24 + $hour)*60 + $min)*60 + $sec;
                $times{$time} = 1;
            }
            else { die "Wrong Time Format: $timestr"; }
                

            print "  car $car [$locx, $locy] at $time\n" if($DEBUG3);
            # $trace{$car}{$time}{X} = $lat;
            # $trace{$car}{$time}{Y} = $lng;
            $trace{$car}{TIME}{$time}{X} = $locx;
            $trace{$car}{TIME}{$time}{Y} = $locy;

        }
        close FH;
    }
}
closedir $dh;



open FH_CAR, "> $output_dir/cars.txt" or die $!;
print "  #car = ".(scalar keys %trace)."\n";
foreach my $this_car (sort {$a <=> $b} keys %trace) {
    # next if (scalar (keys %{$trace{$this_car}}) < 1000);
    print FH_CAR "$this_car, ".(scalar (keys %{$trace{$this_car}{TIME}}))."\n";

    open FH, "> $output_dir/cars/$this_car.txt" or die $!;
    foreach my $this_time (sort {$a <=> $b} keys %{$trace{$this_car}{TIME}}) {
        print FH "$this_time, ".$trace{$this_car}{TIME}{$this_time}{X}.", ".$trace{$this_car}{TIME}{$this_time}{Y}."\n";
    }
    close FH;

    my @tmp = sort {$a <=> $b} keys %{$trace{$this_car}{TIME}};
    print "  car $this_car: #loc=".(keys %{$trace{$this_car}{TIME}}).", time=".($tmp[@tmp-1] - $tmp[0])."\n";
}
close FH_CAR;
# return

my @tmp = sort {$a <=> $b} (keys %times);
print "  overall time = ".($tmp[@tmp-1] - $tmp[0])."\n";

open FH, "> $output_dir/times.txt" or die $!;
print FH join("\n", sort {$a <=> $b} (keys %times))."\n";
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


