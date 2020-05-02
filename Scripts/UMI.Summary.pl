#!/usr/bin/perl
#Informatic Biology departments of Beijing Genomics Institute (BGI) 
use strict;
use luzhk;
use Getopt::Long;
my %opts;

GetOptions(\%opts, "d:s","bait:s","help!");
if (@ARGV != 2) {
	print "usage: .pl TaoH1TActivation.csv out
		-d	distance
		-f	filetype
		\n";
	exit;
}

my $F="";
$F=$opts{"f"} if($opts{'f'} ne "");

my $infile1 = shift;
open(IN1, $infile1) or die $!;
my $outfile = shift;
open(OUT, ">$outfile") or die $!;

Ptime("start!");

my %Barcode;
my $head = <IN1>;
chomp $head;
my @B = split/,/,$head;
for(my$i=1;$i<@B;$i++){
	$B[$i]=~s/-\d//;
	$Barcode{$B[$i]}=0;
}

while (<IN1>) {
#	next if (/^#/);
	chomp;
	my @info = split/,/;
	for(my$i=1;$i<@info;$i++){
		$Barcode{$B[$i]}+=$info[$i];
	}
}
close IN1;

for(my$i=1;$i<@B;$i++){
	print OUT "$B[$i]\t$Barcode{$B[$i]}\n";
}
close IN1;
close OUT;

Ptime("Done!");
