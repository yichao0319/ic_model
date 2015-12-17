#!/bin/perl

##########################################
## Author: Yi-Chao Chen @ Huawei
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
use Math::Trig qw(deg2rad pi great_circle_distance asin acos);
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
my $input_dir  = "./raw_rome_taxi";
my $output_dir = "./processed_rome_taxi";
my $filename = "taxi_february";


#############
# Variables
#############
my $cmd;
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
## uncompress file
#############
$cmd = "gunzip $input_dir/*gz";
`$cmd`;


#############
## read directory
#############
open FH, "$input_dir/$filename.txt" or die $!;
while (<FH>) {
    # print $_;

    if($_ =~ /(\d+);(\d+)-(\d+)-(\d+)\s+(\d+):(\d+):(\d+\.*\d*)\+(\d+);POINT\((-*\d+\.\d+)\s+(-*\d+\.\d+)\)/) {
        my $carid = $1+0;
        my $year = $2+0;
        my $mon = $3+0;
        my $day = $4+0;
        my $hour = $5+0;
        my $min = $6+0;
        # my $sec = $7*(10**$8);
        my $sec = round($7*(10**$8));
        my $locx = $9+0;
        my $locy = $10+0;
        # print "$year-$mon-$day $hour:$min:$sec: car=$carid ($locx, $locy)\n";

        my $time = (((get_month_cumdays($mon-1) + $day)*24 + $hour)*60 + $min)*60 + $sec;
        $times{$time} = 1;

        push(@{$trace{$carid}{TIME}}, $time);
        push(@{$trace{$carid}{X}}, $locx);
        push(@{$trace{$carid}{Y}}, $locy);
    }
    else {
        print $_;
        print "ERROR: Wrong Format\n";
    }

}
close FH;

print "#car = ".(scalar keys %trace)."\n";
foreach my $this_car (sort {$a <=> $b} keys %trace) {
    open FH, "> $output_dir/cars/$this_car.txt" or die $!;
    foreach my $i (0 .. @{$trace{$this_car}{TIME}}-1) {
        print FH "".$trace{$this_car}{TIME}[$i].", ".$trace{$this_car}{X}[$i].", ".$trace{$this_car}{Y}[$i]."\n";
    }
    close FH;
    print "  car $this_car: #loc=".(@{$trace{$this_car}{TIME}})."\n";
}
# return

open FH, "> $output_dir/times.txt" or die $!;
print FH join("\n", sort(keys %times))."\n";
close FH;


#############
## compress file
#############
$cmd = "gzip $input_dir/taxi_february*";
`$cmd`;


# open FH_OUT, ">$output_dir/kddcup99.duration.txt";
# print FH_OUT join("\n", sort {$a <=> $b} @durations)."\n";
# close FH_OUT;

# open FH_OUT, ">$output_dir/kddcup99.ul_byte.txt";
# print FH_OUT join("\n", sort {$a <=> $b} @ul_bytes)."\n";
# close FH_OUT;

# open FH_OUT, ">$output_dir/kddcup99.dl_byte.txt";
# print FH_OUT join("\n", sort {$a <=> $b} @dl_bytes)."\n";
# close FH_OUT;



sub LawCosines {
    my ($lat1, $long1, $lat2, $long2) = @_;
    my $r=3956;

    my $dist = acos(sin(deg2rad($lat1))*
                sin(deg2rad($lat2))+
                cos(deg2rad($lat1))*
                cos(deg2rad($lat2))*
                cos(deg2rad($long2)- deg2rad($long1))) 
                * $r;
    return $dist;

}

sub FlatEarth {
    my ($lat1, $long1, $lat2, $long2) = @_;
    my $r=3956;

    my $a = (pi/2)- deg2rad($lat1);               
    my $b = (pi/2)- deg2rad($lat2);
    my $c = sqrt($a**2 + $b**2 - 2 * $a *$b
            *cos(deg2rad($long2)-deg2rad($long1)));
    my $dist = $c * $r;

    return $dist;

}

sub Haversine {
    my ($lat1, $long1, $lat2, $long2) = @_;
    my $r=3956;

               
    my $dlong = deg2rad($long1) - deg2rad($long2);
    my $dlat  = deg2rad($lat1) - deg2rad($lat2);

    my $a = sin($dlat/2)**2 +cos(deg2rad($lat1)) 
                    * cos(deg2rad($lat2))
                    * sin($dlong/2)**2;
    my $c = 2 * (asin(sqrt($a)));
    my $dist = $r * $c;               


    return $dist;

}

sub GreatCircle {
    my ($lat1, $long1, $lat2, $long2) = @_;
    my $r=3956;
    my @zip1 = (deg2rad($long1), deg2rad(90-$lat1));
    my @zip2 = (deg2rad($long2), deg2rad(90-$lat2));
    my $dist = great_circle_distance(@zip1, @zip2,$r);
                     
    return $dist;
}



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