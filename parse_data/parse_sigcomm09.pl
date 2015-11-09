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
use lib "/u/yichao/utils/perl";
use lib "../utils";

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
my $input_dir  = "./raw_sigcomm09";
my $output_dir = "./processed_sigcomm09";
my $filename = "proximity";

#############
# Variables
#############
my %contact;

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
## Read Data
#############
print "Read Data\n" if($DEBUG2);

open FH, "$input_dir/$filename.csv" or die $!;
<FH>;
my $prev_user = -1;
my $prev_time = -1;
while (<FH>) {
    print $_ if($DEBUG3);
    chomp;
    ## timestamp;user_id;seen_user_id;seen_device_major_cod;seen_device_minor_cod
    my @data = split(/;/, $_);
    my $time = $data[0]+0;
    my $user = $data[1];
    my $seen = $data[2]; 

    if($user != $prev_user) {
        print "====================\n" if($DEBUG3);
        print "New User: $user\n" if($DEBUG3);
        if(exists $contact{$user}) {
            print "ERROR: the user has been seen before\n";
            return;
        }

        $prev_time = -1;
        $prev_user = $user;
    }

    if($time != $prev_time) {
        print "-----------------\n" if($DEBUG3);
        print "New Time: $time\n" if($DEBUG3);

        if(exists $contact{$user}) {
            foreach my $this_seen (sort {$a <=> $b} keys %{$contact{$user}{SEEN}}) {
                if($contact{$user}{SEEN}{$this_seen}{PREV_SEEN} == 0) {
                    ## remain unseen
                    print "  seen user: $this_seen [x]\n" if($DEBUG3);
                }
                elsif($contact{$user}{SEEN}{$this_seen}{PREV_SEEN} == 1) {
                    ## new contact
                    print "  seen user: $this_seen [-]\n" if($DEBUG3);
                    $contact{$user}{SEEN}{$this_seen}{PREV_SEEN} = 2;
                }
                elsif($contact{$user}{SEEN}{$this_seen}{PREV_SEEN} == 2) {
                    ## end of contact
                    my $duration = $prev_time - $contact{$user}{SEEN}{$this_seen}{STD_TIME};
                    print "  seen user: $this_seen [end=$prev_time-".$contact{$user}{SEEN}{$this_seen}{STD_TIME}."=$duration]\n" if($DEBUG3);
                    push(@{$contact{$user}{SEEN}{$this_seen}{DURATIONS}}, $duration);
                    $contact{$user}{SEEN}{$this_seen}{PREV_SEEN} = 0;
                }
                else {
                    ## no way here
                }
            }

        }
        print "-----------------\n" if($DEBUG3);
        $prev_time = $time;
    }

    if(exists $contact{$user}{SEEN}{$seen}) {
        if($contact{$user}{SEEN}{$seen}{PREV_SEEN} == 0) {
            ## new contact
            print "  $seen new\n" if($DEBUG3);
            $contact{$user}{SEEN}{$seen}{PREV_SEEN} = 1;
            $contact{$user}{SEEN}{$seen}{STD_TIME} = $time;
        }
        elsif($contact{$user}{SEEN}{$seen}{PREV_SEEN} == 1) {
            ## no way here...
            print "prev_seen == 1, no way here\n";
            return;
        }
        elsif($contact{$user}{SEEN}{$seen}{PREV_SEEN} == 2) {
            ## seen before
            print "  $seen seen\n" if($DEBUG3);
            $contact{$user}{SEEN}{$seen}{PREV_SEEN} = 1;
        }
        else {
            ## no way here
            print "prev_seen == ".$contact{$user}{SEEN}{$seen}{PREV_SEEN}.", no way here\n";
            return;
        }
    }
    else {
        ## new contact
        print "  $seen new\n" if($DEBUG3);
        $contact{$user}{SEEN}{$seen}{PREV_SEEN} = 1;
        $contact{$user}{SEEN}{$seen}{STD_TIME} = $time;
    }
}
close FH;


#############
## Save Data
#############
print "Save Data\n" if($DEBUG2);

my @durations;
my @seen_users;
foreach my $this_user (keys %contact) {
    push(@seen_users, scalar (keys %{$contact{$this_user}{SEEN}}));
    foreach my $this_seen (keys %{$contact{$this_user}{SEEN}}) {
        if(!exists($contact{$this_user}{SEEN}{$this_seen}{DURATIONS})) {
            print "user $this_user, see $this_seen\n";
            next;
        }
        push(@durations, @{$contact{$this_user}{SEEN}{$this_seen}{DURATIONS}});
    }
}

open FH, ">$output_dir/$filename.dur.txt" or dir $!;
print FH join("\n", @durations);
close FH;

open FH, ">$output_dir/$filename.num_seen.txt" or dir $!;
print FH join("\n", @seen_users);
close FH;
