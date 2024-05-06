#!/usr/bin/perl -w

use strict;

my($grpFile, $pavFile, $col) = ($ARGV[0], $ARGV[1], $ARGV[2]);

chomp($col);
$col = $col -1;

my($sample, $info, %INFO, $gid, @sam, @arr, $i, %TYPE, $cnt, %VAL, %GID, %CLASS);

open IN,'<',$grpFile;
while(<IN>){
  chomp;
  ($sample, $info) = (split/\t/,$_)[0, $col];
  $INFO{$sample} = $info;
  }
  close IN;

open IN,'<',$pavFile;
while(<IN>){
  chomp;
  if(/^GeneID/){
      ($gid, @sam) = split/\t/,$_;
      for($i = 0; $i < @sam; $i++){
         $CLASS{$INFO{$sam[$i]}}++;
         }
      }
      else{
         ($gid, @arr) = split/\t/,$_;
         $cnt = 0;
         %TYPE = ();
         for($i = 0; $i < @arr; $i++){
             $cnt++;
             #print $INFO{$sam[$i]}."\t".$arr[$i]."\n";
             $TYPE{$INFO{$sam[$i]}}++ if $arr[$i] == 1;
             }
         $GID{$gid} = $gid;
         foreach $info (sort keys %TYPE){
             chomp($info);
             #$CLASS{$info} = $info;
             $VAL{$gid}{$info} = $TYPE{$info};
             }
         }
  }
  close IN;

print "GeneID";
foreach $info (sort keys %CLASS){
   chomp($info);
   print "\t".$info;
   }
print "\n";

foreach $gid (sort keys %GID){
  chomp($gid);
  print $gid;
  foreach $info (sort keys %CLASS){
     chomp($info);
     $VAL{$gid}{$info} = 0 if !$VAL{$gid}{$info};
     print "\t".sprintf("%.2f",100*$VAL{$gid}{$info}/$CLASS{$info});
     #print "\t".$VAL{$gid}{$info}.'/'.$CLASS{$info};
     }
  print "\n";
  }
