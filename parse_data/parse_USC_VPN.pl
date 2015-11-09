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
# use DateTime;
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
my $input_dir  = "./raw_USC_VPN_sessions";
my $output_dir = "./processed_USC_VPN_sessions";


#############
# Variables
#############
my $cmd;
my %vpn;
my @durations;
my $pre_time = 0; 
my $pre_mon;


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
$cmd = "gunzip $input_dir/*.gz";
`$cmd`;

#############
## read directory
#############
opendir(my $dh, $input_dir) || die $!;
while(readdir $dh) {
    if($_ =~ /(.*sessions)/) {
        my $filename = $1;
        my $ext = $2;
        print "===========================\n";
        print "$filename\n";

        
        #############
        ## read directory
        #############
        open FH, "$input_dir/$filename" or die $!;
        while (<FH>) {
            print "$_";

            if($_ =~ /(\w+)\s+(\w+)\s+(\d+)\s+(\d+):(\d+):(\d+)\s+(\w+)\s+(\d+\.\d+\.\d+\.\d+)\s+(\d+\.\d+\.\d+\.\d+)/) {
                my $mon_str = $2;
                my $mon = get_month($mon_str);
                my $day = $3 + 0;
                my $hour = $4 + 0;
                my $min = $5 + 0;
                my $sec = $6 + 0;
                my $status = $7;
                my $src = $8;
                my $dst = $9;

                print "$mon-$day-$hour:$min:$sec [$status]: $src -> $dst\n";

                my $time = (((get_month_cumdays($mon-1) + $day)*24 + $hour)*60 + $min)*60 + $sec;
                next if($time < $pre_time);
                $pre_time = $time;
                
                if($status eq "Start") {
                    ## DEBUG
                    if(exists $vpn{"$src->$dst"}) {
                        if($vpn{"$src->$dst"}{TIME} > 0) {
                            print "ERROR: re-start an existing session\n";
                            # return;
                        }
                    }

                    $vpn{"$src->$dst"}{LINE} = $_;
                    $vpn{"$src->$dst"}{TIME} = $time;
                }
                else {
                    next if(!exists($vpn{"$src->$dst"}));

                    my $duration = $time - $vpn{"$src->$dst"}{TIME};
                    if($duration < 0) {
                        print "ERROR: end time < start time\n";
                        print "=====================\n";
                        print "duration = $duration\n";
                        print "pre time = ".$vpn{"$src->$dst"}{TIME}."\n";
                        print "now time = ".$time."\n";
                        print "pre month days so far = ".get_month_cumdays($mon-2)."\n";
                        print "now month days so far = ".get_month_cumdays($mon-1)."\n";
                        print $vpn{"$src->$dst"}{LINE}."\n";
                        print $_."\n";
                        print "=====================\n";
                        return;
                    }
                    push(@durations, $duration);

                    $vpn{"$src->$dst"}{TIME} = -1;
                }
            }
        }
        close FH;

    }
}
closedir $dh;

#############
## compress file
#############
$cmd = "gzip $input_dir/*sessions";
`$cmd`;


open FH_OUT, ">$output_dir/USC_VPN_sessions.length.txt";
print FH_OUT join("\n", sort {$a <=> $b} @durations)."\n";
close FH_OUT;



##########################################

sub get_month {
    my $str = $_[0];

    if($str eq "Apr") {
        return 4;
    }
    elsif($str eq "May") {
        return 5;
    }
    elsif($str eq "Jun") {
        return 6;
    }
    elsif($str eq "Jul") {
        return 7;
    }
    elsif($str eq "Aug") {
        return 8;
    }
    else {
        return -1;
    }
}


sub get_month_days {
    my $mon = $_[0];

    my @days = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
    return $days[$mon-1];
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


