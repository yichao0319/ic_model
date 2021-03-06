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
my $input_dir  = "./raw_netflix";
my $output_dir = "./processed_netflix";


#############
# Variables
#############


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
## Read data
#############
my $movie;
my $user;

my %movie_rates = ();
my %user_rates = ();

open FH, "$input_dir/TrainingRatings.txt" or die $!;
while(<FH>) {
    if($_ =~ /(\d+),(\d+),(\d+\.\d+)/) {
        $movie = $1 + 0;
        $user = $2 + 0;

        $movie_rates{$movie}{$user} = 1;
        $user_rates{$user}{$movie} = 1;
    }
    else{
        print "Wrong Format: $_\n";
        return;
    }
}
close FH;

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
# print join(",", sort {$a <=> $b} @movie_rate_number)."\n";

open FH_OUT1, ">$output_dir/training.movie_rate_cnt.txt";
print FH_OUT1 join("\n", sort {$a <=> $b} @movie_rate_number)."\n";
close FH_OUT1;

print "------------------\n";

my @user_rate_number = ();
foreach my $this_user (sort {$a <=> $b} keys %user_rates) {
    push(@user_rate_number, scalar keys %{$user_rates{$this_user}});
}
# print join(",", sort {$a <=> $b} @user_rate_number)."\n";

open FH_OUT2, ">$output_dir/training.user_rate_cnt.txt";
print FH_OUT2 join("\n", sort {$a <=> $b} @user_rate_number)."\n";
close FH_OUT2;
