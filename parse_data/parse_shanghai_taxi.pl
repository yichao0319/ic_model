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
my $DEBUG3 = 1; ## print output


#############
# Constants
#############
my $input_dir  = "./raw_shanghai_taxi";
my $output_dir = "./processed_shanghai_taxi";
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
print "Decompress\n" if($DEBUG2);

my $cmd = "gunzip $input_dir/*gz";
`$cmd`;


#############
## read directory
#############
opendir(my $dh, $input_dir) || die $!;
while(readdir $dh) {
    chomp;
    if($_ =~ /(Taxi.*)/) {
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
            my @data = split(/,/, $_);
            my $car = $data[0];
            my $lng = $data[2] + 0;
            my $lat = $data[3] + 0;

            my $time = 0;
            if($data[1] =~ /(\d+)-(\d+)-(\d+)\s+(\d+):(\d+):(\d+)/) {
                my $year = $1 + 0;
                my $mon = $2 + 0;
                my $day = $3 + 0;
                my $hour = $4 + 0;
                my $min = $5 + 0;
                my $sec = $6 + 0;
                $time = (((get_month_cumdays($mon-1) + $day)*24 + $hour)*60 + $min)*60 + $sec;

                $times{$time} = 1;
            }

            print "  car $car [$lat, $lng] at $time\n" if($DEBUG3);
            $trace{$car}{$time}{X} = $lat;
            $trace{$car}{$time}{Y} = $lng;

        }
        close FH;
    }
}
closedir $dh;


print "  #car = ".(scalar keys %trace)."\n";
foreach my $this_car (sort {$a <=> $b} keys %trace) {
    next if (scalar (keys %{$trace{$this_car}}) < 1000);

    open FH, "> $output_dir/cars/$this_car.txt" or die $!;
    foreach my $this_time (sort {$a <=> $b} keys %{$trace{$this_car}}) {
        print FH "$this_time, ".$trace{$this_car}{$this_time}{X}.", ".$trace{$this_car}{$this_time}{Y}."\n";
    }
    close FH;

    my @tmp = sort {$a <=> $b} keys %{$trace{$this_car}};
    print "  car $this_car: #loc=".(keys %{$trace{$this_car}}).", time=".($tmp[@tmp-1] - $tmp[0])."\n";
}
# return

my @tmp = sort {$a <=> $b} (keys %times);
print "  overall time = ".($tmp[@tmp-1] - $tmp[0])."\n";

open FH, "> $output_dir/times.txt" or die $!;
print FH join("\n", sort {$a <=> $b} (keys %times))."\n";
close FH;


#############
## compress
#############
print "Compress\n" if($DEBUG2);

my $cmd = "gzip $input_dir/Taxi* taxi.gzip";
`$cmd`;





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


