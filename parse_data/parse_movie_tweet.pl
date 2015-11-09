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
my $input_dir  = "./raw_movietweetings";
my $output_dir = "./processed_movietweetings";
my @filenames = ("training.dat", "evaluation.dat", "test.dat");


#############
# Variables
#############
my $cmd;


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
## decompress data
#############
$cmd = "gunzip $input_dir/*gz";
`$cmd`;


#############
## Read data
#############
my $movie;
my $user;

my %movie_rates = ();
my %user_rates = ();

foreach my $filename (@filenames) {
    open FH, "$input_dir/$filename" or die $!;
    <FH>;
    while(<FH>) {
        my @ret = split(/,/, $_);
        $user = $ret[0];
        $movie = $ret[1];

        $movie_rates{$movie}{$user} = 1;
        $user_rates{$user}{$movie} = 1;
    }
    close FH;
}

#############
## decompress data
#############
$cmd = "gzip $input_dir/*dat";
`$cmd`;


#############
## process data
#############
print "------------------\n";

print "# movies = ".(scalar keys %movie_rates)."\n";
print "# users  = ".(scalar keys %user_rates)."\n";

print "max movie = ".max(keys %movie_rates)."\n";
print "min movie = ".min(keys %movie_rates)."\n";


print "------------------\n";

my @movie_rate_number = ();
foreach my $this_movie (sort {$a <=> $b} keys %movie_rates) {
    push(@movie_rate_number, scalar keys %{$movie_rates{$this_movie}});
}
print join(",", sort {$a <=> $b} @movie_rate_number)."\n";
open FH_OUT1, ">$output_dir/movietweetings.movie_rate_cnt.txt";
print FH_OUT1 join("\n", sort {$a <=> $b} @movie_rate_number)."\n";
close FH_OUT1;

print "------------------\n";

my @user_rate_number = ();
foreach my $this_user (sort keys %user_rates) {
    push(@user_rate_number, scalar keys %{$user_rates{$this_user}});
}
print join(",", sort {$a <=> $b} @user_rate_number)."\n";

open FH_OUT2, ">$output_dir/movietweetings.user_rate_cnt.txt";
print FH_OUT2 join("\n", sort {$a <=> $b} @user_rate_number)."\n";
close FH_OUT2;
