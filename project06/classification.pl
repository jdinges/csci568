#!/usr/bin/perl

use constant TRUE => 1;
use constant FALSE => 0;

use constant VOWELS => qw(a e i o u);
use constant TOTAL_VOWELS => 5;
use constant OFFICE_CHARACTERS => (
	"Michael Scott",
	"Dwight Schrute",
	"Jim Halpert",
	"Andy Bernard",
	"Creed Bratton",
	"Pam Beasely",
	"Pam Halpert",
	"Phyllis Vans"
);

&runMain();

sub runMain
{
	if($#ARGV + 1 != 1){
		print"Provide an input file containing your data\n\ncluster.pl <filename>\n";
		exit 0;
	}
	my $filename = $ARGV[0];
	print"Going to read $filename...\n";
	my @contents = &readCSV($filename);
	my @list = &sortCSV([@contents]);
	my($vowelsRef, $consonantsRef) = &splitOnSecondLetterFirstName([@list]);
	my($actorsRefVowels, $civiliansRefVowels) = &splitOnCharacterFromTheOffice($vowelsRef);
	my($actorsRefConsonants, $civiliansRefConsonants) = &splitOnCharacterFromTheOffice($consonantsRef);
	

}

sub splitOnCharacterFromTheOffice
{
	my($listRef) = @_;
	my @list = @{$listRef};
	
	my @actors = ();
	my @civilians = ();
	
	foreach my $classificationRef (@list){
		my @classifications = @{$classificationRef};
		my ($name, $status) = @classifications;
		if(&isCharacterFromTheOffice($name)){
			push(@actors,$classificationRef);
		} else {
			push(@civilians,$classificationRef);
		}
	}
	
	&determineResults([@actors],"actors","characters from the office");
	&determineResults([@civilians],"civilians","characters from the office");
	
	return([@actors], [@civilians]);
}

sub isCharacterFromTheOffice
{
	my($name) = @_;
	my $isCharacter = FALSE;
	foreach my $character ( OFFICE_CHARACTERS ){
		if($name eq $character){
			$isCharacter = TRUE;
			last;
		}
	}
	return $isCharacter;
}

sub splitOnSecondLetterFirstName
{
	my($listRef) = @_;
	my @list = @{$listRef};
	
	my @vowels = ();
	my @consonants = ();
	
	foreach my $classificationRef (@list){
		my @classifications = @{$classificationRef};
		my ($name, $status) = @classifications;
		my @nameArray = split(//,$name);
		if(&isVowel($nameArray[1])){
			push(@vowels,$classificationRef);
		} else {
			push(@consonants,$classificationRef);
		}
	}
	
	#------------------------------------------------#
	# Uncomment the section below to print the split #
	#------------------------------------------------#
	#foreach my $classVowel (@vowels){
		#chomp($classVowel->[1]);
		#print"$classVowel->[1], $classVowel->[0]\n";
	#}
	#foreach my $classConsonant (@consonants){
		#chomp($classConsonant->[1]);
		#print"$classConsonant->[1], $classConsonant->[0]\n";
	#}
	
	&determineResults([@vowels],"vowels","vowels as second letter of first name");
	&determineResults([@consonants],"consonants","vowel as second letter of first name");
	
	return([@vowels], [@consonants]);
}

sub determineResults
{
	my($listRef, $thisClass, $splitType) = @_;
	my @list = @{$listRef};
	my $winnersPercent = &percentWinners([@list]) * 100;
	my $losersPercent = 100 - $winnersPercent;
	
	print"The winner/loser split on $thisClass for $splitType...\n";
	print"\tWinner: $winnersPercent%\n";
	print"\tLoser: $losersPercent%\n\n";
	
	return ($winnersPercent, $losersPercent);
}

sub percentWinners
{
	my($listRef) = @_;
	my @list = @{$listRef};
	my $listSize = @list;
	my $totalWinners = 0;
	my $winner = " + ";
	foreach my $person (@list){
		chomp($person->[1]);
		if($person->[1]=~/\+/){
			$totalWinners = $totalWinners + 1;
		}
	}
	return $totalWinners/$listSize;
}

sub isVowel
{
	my($letter) = @_;
	my $isVowel = FALSE;
	foreach my $vowel ( VOWELS ){
		if(lc($letter) eq $vowel){
			$isVowel = TRUE;
			last;
		}
	}
	return $isVowel;
}

sub readCSV
{
    my($targetFile) = @_;
    if(!(-e $targetFile)){
	print"File $targetFile does not exist within the specified path.\n";
	exit 1;
    }

    open(FIL,$targetFile);
    my @contents = <FIL>;
    close(FIL);

    return @contents;
}

sub sortCSV
{
	my($arrayRef) = @_;
	my @array = @{$arrayRef};
	my @returnArray = ();
	foreach my $line (@array) {
		if($line=~/\w+/){
			my @attributes = split(/,/,$line);
			push(@returnArray, [@attributes]);
		}
	}
	return @returnArray
}