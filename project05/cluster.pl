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
		
		# cluster
		for(my $i = 0; $i < $k; $i++){
			my @totalcluster = (0, 0, 0, 0);
			my $clustercount = 0;
			# cluster-data map
			for(my $j = 0; $j < $clusterSize; $j++){
				my $element = $clusterList[$j]; 
				if($element == $i){
					$clustercount++;
					my @dataArray = @{$data[$j]};
					my $dataArraySize = @dataArray;
					
					# data
					for(my $a = 0; $a<$dataArraySize; $a++){
						my $attribute = $dataArray[$a];
						if($attribute=~/\d+/){
							$totalcluster[$a] = $totalcluster[$a] + $attribute;
							#print"Cluster $i, Data Point $j, totalcluster[$a] = $totalcluster[$a]\n";
						} elsif ($clustercount) {
							print"no attribute increase\n";
						}
					}
				}
			}
			# average
			my $totalClusterSize = @totalcluster;
			print"Cluster #$i centroid = ";
			if($clustercount != 0){
				for(my $b = 0; $b<$totalClusterSize; $b++){
					my $totalattribute = $totalcluster[$b];
					if($totalattribute=~/\d+/){
						$totalcluster[$b] = $totalattribute / $clustercount; 
						print"$totalcluster[$b], ";
					}
				}
				print"\n";
				# update centroid
				$karray[$i] = [@totalcluster];
			} else {
				print"$karray[$i]->[0], $karray[$i]->[1], $karray[$i]->[2], $karray[$i]->[3] ... NO MATCH";
				print"\n";
			}
		}
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