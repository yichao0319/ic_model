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
use lib "/u/yichao/utils/perl";
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
my $input_dir  = "./raw_kddcup99";
my $output_dir = "./processed_kddcup99";
my $filename = "kddcup.data";

#############
# Variables
#############
my $cmd;
my @durations;
my @ul_bytes;
my @dl_bytes;


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
$cmd = "gunzip $input_dir/$filename.gz";
`$cmd`;


#############
## read directory
#############
open FH, "$input_dir/$filename" or die $!;
while (<FH>) {
    # print $_;

    my @data = split(/,/, $_);
    my $duration = $data[0] + 0;
    my $ul_byte = $data[4] + 0;
    my $dl_byte = $data[5] + 0;
    # print "$duration, $ul_byte - $dl_byte\n";

    push(@durations, $duration);
    push(@ul_bytes, $ul_byte);
    push(@dl_bytes, $dl_byte);
}
close FH;

#############
## compress file
#############
$cmd = "gzip $input_dir/$filename";
`$cmd`;


open FH_OUT, ">$output_dir/kddcup99.duration.txt";
print FH_OUT join("\n", sort {$a <=> $b} @durations)."\n";
close FH_OUT;

open FH_OUT, ">$output_dir/kddcup99.ul_byte.txt";
print FH_OUT join("\n", sort {$a <=> $b} @ul_bytes)."\n";
close FH_OUT;

open FH_OUT, ">$output_dir/kddcup99.dl_byte.txt";
print FH_OUT join("\n", sort {$a <=> $b} @dl_bytes)."\n";
close FH_OUT;
