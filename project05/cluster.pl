#!/usr/bin/perl

use constant MAX_LENGTH => 10;
use constant NUMBER_ATTRIBUTES => 4;

&runMain;

sub runMain
{
	if($#ARGV + 1 != 1){
		print"Provide an input file containing your data\n\ncluster.pl <filename>\n";
		exit 0;
	}
	my $filename = $ARGV[0];
	print"Going to read $filename...\n";
	my @contents = &readCSV($filename);
	my @data = &sortCSV([@contents]);
	&KMeans(2, [@data]);
}

sub KMeans
{
	my($k, $listRef) = @_;
	my @data = @{$listRef};
	my $datasize = @data;
	
	# Generate K random data points
	my @karray = ();
	for($i = 0; $i<$k; $i++){
		my @randomAttributes = ();
		for($j = 0; $j<NUMBER_ATTRIBUTES; $j++){
			my $newnumber = rand(MAX_LENGTH);
			push(@randomAttributes, $newnumber);
		}
		push(@karray, [@randomAttributes]);
	}
	
	# Calculate the euclidean distance for each point compared to each centroid
	my @clusters = ();
	for(my $i = 0; $i < $k; $i++){
		my @keuclidean = ();
		my $comparek = $karray[$i];
		#print"For k = $comparek->[0],$comparek->[1],$comparek->[2],$comparek->[3]\n";
		foreach my $datapoint (@data){
			my $eValue = &euclideanDistance($datapoint, $comparek);
			#print"Euclidean Distance of $datapoint->[0], $datapoint->[1], $datapoint->[2], $datapoint->[3] = $eValue\n";
			push(@keuclidean,$eValue);
		}
		#print"\n";
		push(@clusters,[@keuclidean]);
	}
	
	for(my $i = 0; $i < $datasize; $i++){
		my @comparable = ();
		foreach my $kEuclid (@clusters){
			push(@comparable, $kEuclid->[$i]);
		}
		my @ordered = sort(@comparable);
		#print"$ordered[0], $ordered[1] VS. $comparable[0], $comparable[1]\n";
	}
}

sub euclideanDistance
{
	my($distRef, $datRef) = @_;
	my @dist = @{$distRef};
	my $distSize = @dist;
	my @dat = @{$datRef};
	my $datSize = @dat;
	
	if($distSize -1 != $datSize){
		print"distSize = $distSize NOT EQUAL datSize = $datSize\n";
		return -1;
	}
	
	my $total = 0;
	for($i = 0; $i < $distSize - 1; $i++){
		my $distElement = $dist[$i];
		my $datElement = $dat[$i];
		
		$total += ($distElement - $datElement) ** 2;
	}
	return $total ** (1/2)
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