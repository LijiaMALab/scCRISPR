#!/usr/bin/perl
#Westlake University
use strict;
use luzhk;
use Getopt::Long;
my %opts;

GetOptions(\%opts, "p:f","f:s","help!");
if (@ARGV != 3) {
	print "usage: .pl *.barcode.summary *cellbarcode out
		-p	minimal fraction of the secondary gRNA(by default 0.1)
		-f	filetype
		\n";
	exit;
}

my $F="";
$F=$opts{"f"} if($opts{'f'} ne "");
my $minP=0.1;
$minP=$opts{"p"} if($opts{'p'} ne "");

my $infile1 = shift;
open(IN1, $infile1) or die $!;
my $infile2 = shift;
open(IN2, $infile2) or die $!;
my $outfile = shift;
open(OUT, "|sort -k2,2nr >$outfile") or die $!;

Ptime("start!");

my %BarcodeUMI;
while (<IN1>) {
	next if (/^#/);
	chomp;
	my @info = split/\t/;
	$BarcodeUMI{$info[0]} = $info[1];
}
close IN1;

my %Barcode;
while (<IN2>) {
	next if (/^#/);
	chomp;
	my @info = split/\t/;
	$Barcode{$info[1]}{$info[3]}{'UMI'}{$info[2]} = $info[0];
	$Barcode{$info[1]}{$info[3]}{'UMINum'}++;
	$Barcode{$info[1]}{$info[3]}{'TotalNum'}+=$info[0];
}
close IN2;

foreach my $B(keys %Barcode){
	my $out;
	foreach my $g(sort{if($Barcode{$B}{$b}{'UMINum'} == $Barcode{$B}{$a}{'UMINum'}){
				$Barcode{$B}{$b}{'TotalNum'} <=> $Barcode{$B}{$a}{'TotalNum'};
			}else{
				$Barcode{$B}{$b}{'UMINum'} <=> $Barcode{$B}{$a}{'UMINum'};
			}
			} keys %{$Barcode{$B}}){
		$out .= "$g\t$Barcode{$B}{$g}{'UMINum'}\t$Barcode{$B}{$g}{'TotalNum'}\t";
	}
	chop $out;
	print OUT "$B\t$BarcodeUMI{$B}\t$out\n";
}

close OUT;

Ptime("Done!");
