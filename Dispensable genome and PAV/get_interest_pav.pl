#!/usr/bin/perl -w

use strict;

my $file = $ARGV[0]; # CSS_CSA_PAV.txt
my $str = $ARGV[1];  # 2,5 means col2 and col5
my $cutoff = $ARGV[2]; # cutoff

chomp($cutoff);

my($col1, $col2) = split/\,/,$str;
$col1 = $col1 - 2;
$col2 = $col2 - 2;

my($gid, @arr);

open IN,'<',$file;
while(<IN>){
  chomp;
  if(/^GeneID/){
     print $_."\n";
     }
     else{
        ($gid, @arr) = split/\t/,$_;
        print $_."\n" if abs($arr[$col1] - $arr[$col2]) >= $cutoff;
        }
  }
  close IN;
