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
	my @clusterList = ();
	# Calculate maximums for each attribute
	my @maximums;
	for(my $i = 0; $i<NUMBER_ATTRIBUTES; $i++){
		my @localmaximums = ();
		for(my $j = 0; $j<$datasize; $j++){
			#print"data[$j]->[$i] = $data[$j]->[$i]\n";
			push(@localmaximums,$data[$j]->[$i]);
		}
		my $max = (sort {$a <=> $b} @localmaximums)[-1];
		#print"Max for attribute $i = $max\n";
		push(@maximums,$max);
	}
	
	# Generate K random data points
	my @karray = ();
	for($i = 0; $i<$k; $i++){
		my @randomAttributes = ();
		for($j = 0; $j<NUMBER_ATTRIBUTES; $j++){
			my $newnumber = rand($maximums[$j]);
			push(@randomAttributes, $newnumber);
		}
		push(@karray, [@randomAttributes]);
	}
	
	for(my $h = 0; $h < 5; $h++){
		@clusterList = ();
		# Calculate the euclidean distance for each point compared to each centroid
		my @clusters = ();
		for(my $i = 0; $i < $k; $i++){
			my @keuclidean = ();
			my $comparek = $karray[$i];
			print"For k = $comparek->[0],$comparek->[1],$comparek->[2],$comparek->[3]\n";
			foreach my $datapoint (@data){
				my $eValue = &euclideanDistance($datapoint, $comparek);
				#print"Euclidean Distance of $datapoint->[0], $datapoint->[1], $datapoint->[2], $datapoint->[3] = $eValue\n";
				push(@keuclidean,$eValue);
			}
			#print"\n";
			push(@clusters,[@keuclidean]);
		}
	
		# Organize into clusters. Use cluster list. The index of clusterList maps to the data point
		# and the value at that index maps to which cluster the data point belongs in.
		for(my $i = 0; $i < $datasize; $i++){
			my @comparable = ();
			foreach my $kEuclid (@clusters){
				push(@comparable, $kEuclid->[$i]);
			}
			my @ordered = sort {$a <=> $b} (@comparable);
			#print"$ordered[0], $ordered[1] VS. $comparable[0], $comparable[1]\n";
			my $target = $ordered[0];
			my $index = -1;
			for(my $j = 0; $j < $k; $j++){
				if($comparable[$j] == $target){
					#print"match! $comparable[$j] = $target\t => index = $j\n";
					$index = $j;
					last;
				}
			}
			push(@clusterList, $index);
		}
	
		my $clusterSize = @clusterList;
		for(my $i = 0; $i<$datasize; $i++){
			print"Data Point = $data[$i]->[0], $data[$i]->[1], $data[$i]->[2], $data[$i]->[3]\t => \t#$clusterList[$i]\n";
		}
		
		&CalculateCentroid([@clusterList], [@data], $k);
		
	}
	
}

sub CalculateCentroid
{
	my($clusterRef, $dataRef, $k) = @_;
	my @clusterList = @{$clusterRef};
	my $clusterLength = @clusterList;
	my @data = @{$dataRef};
	my $dataLength = @data;
	
	if($dataLength != $clusterLength){
		print"Data Length = $dataLength DOES NOT EQUAL Cluster Length = $clusterLength\n";
		exit 0;
	}
	
	my @clusterCounts = (0, 0);
	for(my $i = 0; $i < $k; $i++){
		for(my $j = 0; $j < $clusterLength; $j++){
			if($clusterList[$j] == $i){
				$clusterCounts[$i] = $clusterCounts[$i] + 1;
			}
		}
	}
	
	for(my $i = 0; $i < $k; $i++){
		print"Cluster $i has $clusterCounts[$i]\n";
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