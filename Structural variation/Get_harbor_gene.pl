#!/usr/bin/perl -w

use strict;

my $gffFile = $ARGV[0]; # gff3
my $dmrFile = $ARGV[1]; # DMR bed
#my $flankLen = $ARGV[2]; # flanking length

if(!$gffFile || !$dmrFile){
  print "\nperl $0 gff3_file dmr_bed\n\n";
  exit;
  }

my(@arr, $id, $pos, %Gene, %DMG);

open IN,'<',$gffFile;
while(<IN>){
  chomp;
  @arr = split/\t/,$_;
  next if $arr[2] ne 'gene';
  ($id) = (split/\=/,$arr[-1])[1];
  $id =~ s/\;//;
  foreach $pos ($arr[3]..$arr[4]){
     $Gene{$arr[0]}{$pos} = $id;
     }
  }
  close IN;

open IN,'<',$dmrFile;
while(<IN>){
  chomp;
  @arr = split/\t/,$_;
  %DMG = ();
  foreach $pos ($arr[1]..$arr[2]){
     next if !$Gene{$arr[0]}{$pos};
     $DMG{$Gene{$arr[0]}{$pos}} = 1;
     }
  print $_;
  foreach $id (sort keys %DMG){
     $id = 'NA' if !$id;
     print "\t".$id;
     }
  print "\n";
  }
