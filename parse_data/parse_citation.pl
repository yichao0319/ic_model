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
my $input_dir  = "./raw_citation";
my $output_dir = "./processed_citation";
# my $filename = "publications";

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
## uncompress file
#############
$cmd = "gunzip $input_dir/*.gz";
`$cmd`;


#############
## read directory
#############
opendir(my $dh, $input_dir) || die $!;
while(readdir $dh) {
    if($_ =~ /(.*)\.txt/) {
        my $filename = $1;
        print $filename."\n";

        my @citations;
        my @num_coauthors;

        read_data($input_dir, $output_dir, $filename, \@citations, \@num_coauthors);
        print "  #papers=".(@citations)."\n";
        print "  #authors=".(@num_coauthors)."\n";
    }
}
closedir $dh;


#############
## compress file
#############
$cmd = "gzip $input_dir/*.txt";
`$cmd`;


sub read_data {
    ## citations: number of citations of each paper
    ## one_author_citations: number of citations of a author's each paper
    ## coauthors: number of coauthors of each author
    my ($input_dir, $output_dir, $filename, $citations_ref, $coauthors_ref) = @_;
    
    #############
    ## read data
    #############
    print "Read Data\n" if($DEBUG2);

    ## authors: authors and their a) citation number, and b) coauthors
    my %authors;

    my $paper = -1;
    my @this_authors = ();
    my $cnt;
    
    open FH, "$input_dir/$filename.txt" or die $!;
    while (<FH>) {
        chomp();
        if($_ =~ /\#\*/) {
            ## new paper comes
            if($paper > 0) {
                print "    #citations=$cnt\n" if($DEBUG3);
                push(@$citations_ref, $cnt);

                foreach my $this_author (@this_authors) {
                    push(@{$authors{$this_author}{CITATION}}, $cnt);
                }
                @this_authors = ();
            }

            print "\n  New paper:\n" if($DEBUG3);
        }
        elsif($_ =~ /\#index(\d+)/) {
            $paper = $1 + 0;
            print "    paper ID: $paper\n" if($DEBUG3);
            
            $cnt = 0;
        }
        elsif($_ =~ /\#\%(\d+)/) {
            my $ref_paper = $1;
            print "    reference: $ref_paper\n" if($DEBUG3);
            
            $cnt ++;
        }
        elsif($_ =~ /\#\@(.*\w+)/) {
            my @authors = split(/,/, $1);

            foreach my $ai1 (0 .. @authors-1) {
                my $author1 = $authors[$ai1];
                push(@this_authors, $author1);
                print "    author: $author1 <<\n" if($DEBUG3);

                if(!exists $authors{$author1}) {
                    %{$authors{$author1}{COAUTHOR}} = ();
                    @{$authors{$author1}{CITATION}} = ();
                }

                foreach my $ai2 (0 .. @authors-1) {
                    next if($ai1 == $ai2);

                    my $author2 = $authors[$ai2];

                    if(exists $authors{$author1}{COAUTHOR}{$author2}) {
                        $authors{$author1}{COAUTHOR}{$author2} ++;
                    }
                    else {
                        $authors{$author1}{COAUTHOR}{$author2} = 1;
                    }
                }
            }
        }
    }
    push(@$citations_ref, $cnt);
    close FH;


    #############
    ## number of citations of all papers
    #############
    open FH_OUT, ">$output_dir/$filename.num_cite_all_papers.txt";
    print FH_OUT join("\n", sort {$a <=> $b} @$citations_ref)."\n";
    close FH_OUT;


    #############
    ## a) find the top 5 authors with the most citations
    ## b) number of citations of one author's papers
    #############
    my @citations_of_author;
    foreach my $this_author (keys %authors) {
        push(@citations_of_author, sum(@{$authors{$this_author}{CITATION}}));
    }
    @citations_of_author = sort {$b <=> $a} @citations_of_author;
    foreach my $this_author (keys %authors) {
        if(sum(@{$authors{$this_author}{CITATION}}) > $citations_of_author[5]) {
            open FH_OUT, ">$output_dir/$filename.num_cite_one_author.$this_author.txt";
            print FH_OUT join("\n", sort {$a <=> $b} @{$authors{$this_author}{CITATION}})."\n";
            close FH_OUT;
        }
    }

    #############
    ## number of co-authors of each author
    #############
    foreach my $this_author (keys %authors) {
        push(@$coauthors_ref, scalar keys %{$authors{$this_author}{COAUTHOR}});
    }
    @$coauthors_ref = sort {$b <=> $a} @$coauthors_ref;
    open FH_OUT, ">$output_dir/$filename.num_coauthor_all_authors.txt";
    print FH_OUT join("\n", @$coauthors_ref)."\n";
    close FH_OUT;


    #############
    ## a) find the top 5 authors with the most co-authors
    ## b) number of co-working times of one author's co-authors
    #############
    foreach my $this_author (keys %authors) {
        if((scalar keys %{$authors{$this_author}{COAUTHOR}}) > $coauthors_ref->[5]) {
            open FH_OUT, ">$output_dir/$filename.num_coauthor_times_one_author.$this_author.txt";
            print FH_OUT join("\n", sort {$a <=> $b} (values %{$authors{$this_author}{COAUTHOR}}))."\n";
            close FH_OUT;
        }
    }

}

