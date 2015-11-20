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
my $DEBUG3 = 0; ## print output


#############
# Constants
#############
my $input_dir  = "./raw_aps_citation";
my $output_dir = "./processed_aps_citation";
my $filename = "aps-dataset-citations-2013";


#############
# Variables
#############
my $cmd;
my %data;
my %info;

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
# $cmd = "gunzip $input_dir/*.gz";
# `$cmd`;


#############
## read file
#############
print "Read File\n" if($DEBUG2);

open FH, "$input_dir/$filename.csv" || die $!;
<FH>;
while(<FH>) {
    print $_ if($DEBUG3);

    chomp;
    my @tmp = split(/,/, $_);
    my $citing = $tmp[0];
    my $cited = $tmp[1];
    print "  $citing -> $cited\n" if($DEBUG3);

    $data{$cited}{$citing} = 1;
    $info{CITED}{$cited} = 1;
    $info{CITING}{$citing} = 1;
    $info{ALL}{$cited} = 1;
    $info{ALL}{$citing} = 1;
}
close FH;

print "  #papers: ".(keys %{$info{ALL}})."\n";
print "  #cited: ".(keys %{$info{CITED}})."\n";
print "  #citing: ".(keys %{$info{CITING}})."\n";

print join("\n", (keys %{$info{CITED}}))."\n";

#############
## compress file
#############
# $cmd = "gzip $input_dir/*.txt";
# `$cmd`;


#############
## Count the degree
#############
print "Count the degree\n" if($DEBUG2);

my @degrees;
foreach my $node (keys %data) {
    push(@degrees, scalar(keys %{$data{$node}}));
}
@degrees = sort {$a <=> $b} @degrees;


open FH, ">$output_dir/$filename.txt" or die $!;
print FH join("\n", @degrees);
close FH;
