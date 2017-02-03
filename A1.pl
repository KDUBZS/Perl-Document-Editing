#!/usr/bin/perl
#use strict;
use warnings;

sub theTime {
	$inputTime = 0;

	until($inputTime =~ /(([01][0-9])|([2][0-3])):[0-5][0-9]/){
		print ("Enter the time in the form HH:MM\n");
		chomp ($inputTime = <STDIN>);
		if ($inputTime !~ /(([01][0-9])|([2][0-3])):[0-5][0-9]/){
			print ("invalid time, try again.\n");
		}
	}
	print "Your time is $inputTime\n";
}

sub theDate {
	$inputDate = 0;
	$dateGood = 0;
	@daysInMonth = (0,31,28,31,30,31,30,31,31,30,31,30,31);
	@daysInMonthLeap = (0,31,29,31,30,31,30,31,31,30,31,30,31);

	while($dateGood == 0){
		print "Enter the date in the form YYYY-MM-DD\n";	
		chomp ($inputDate = <STDIN>);
		if($inputDate =~ /^(\d{4})-(\d{2})-(\d{2})$/){
			$year = $1;
			$month = $2;
			$day = $3;
			if ($month <= 12 && $day <= $daysInMonth[$month]){
				$dateGood = 1;
			}
			if ($year % 4 == 0 && $month <= 12 && $day <= $daysInMonthLeap[$month]){
				$dateGood = 1;
			}
		}
		else {
			print "invalid date, try again.\n";
		}	
	}
	print "Your date is $inputDate\n";
}

sub editFile {
	$file = 0;
	
	until ($file =~ /^\w*.txt$/){
		print "Enter a file path.\n";
		chomp ($file = <STDIN>);
	}

	print "executing file edit...\n";

	#book
	open ($INDATA, $file) or die "Can't open file.";
	#stuff taken out
	open ($DELETED,">","deletedItems.txt") or die "Can't open file.";
	#edited file
	open ($NEW,">","newTextFile.txt") or die "Can't open file.";;

	while ($line = <$INDATA>){
		if ($line =~ /(=begin comment).*/){
			until ($line =~ /(=cut)/) {
				print ($DELETED $1);
				$line = <$INDATA>;
			}
			print ($DELETED $line);
		}
		else {
			$line =~ s/<h>([\w\W]*?)<\/h>/\U$1/g;
			$line =~ s/(\*DATE\*)/$inputDate/g;
			$line =~ s/(\*TIME\*)/$inputTime/g;
			if ($line =~ /(.*)(#.*)/){
				print ($NEW $1."\n");
				print ($DELETED $2);
			}
			else {
				print ($NEW $line);
			}
		}
	}
}

sub main {
	theTime;
	theDate;
	editFile;
}
main();