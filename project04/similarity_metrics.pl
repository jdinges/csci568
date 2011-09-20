#!/usr/bin/perl

&test_euclidean;
&test_smc;
&test_jaccard;
&test_pearson_1;
&test_pearson_2;
&test_pearson_3;
&test_cosine;


sub test_euclidean{
	print"Testing Euclidean Distance\n";
	my @vector_01 = (1, 2, 3);
	my @vector_02 = (4, 5, 6);
	my $actual_euclidean = 5.19615242270663;
	my $eDistance = &euclideanDistance([@vector_01], [@vector_02]);
	if($actual_euclidean == $eDistance){
		print"Euclidean Distance = $eDistance\n\n";
	} else {
		print"Euclidean Distance failed\n$actual_euclidean != $eDistance\n\n";
	}
}
	
sub test_smc
{
	print"Testing SMC\n";
	my @vector_03 = (0, 1, 1, 0, 1);
	my @vector_04 = (1, 1, 1, 0, 1);
	my $actual_smc = 0.8;
	my $smc = &SMC([@vector_03], [@vector_04]);
	if($actual_smc == $smc){
		print"SMC = $smc\n\n";
	} else {
		print"SMC failed!\n$actual_smc != $smc\n\n";
	}
}

sub test_jaccard
{
	print"Testing Jaccard\n";
	my @vector_05 = (1, 1, 0, 0, 0, 1);
	my @vector_06 = (0, 1, 0, 1, 0, 1);
	my $actual_jaccard = 0.5;
	my $jac = &jaccard([@vector_05], [@vector_06]);
	if($actual_jaccard == $jac){
		print"Jaccard = $jac\n\n";
	} else {
		print"Jaccard failed!\n$actual_jaccard != $jac\n\n";
	}
}

sub test_pearson_1
{
	print"Testing Pearson #1\n";
	my @vector_07 = (-3, -2, -1, 0, 1, 2, 3);
	my @vector_08 = (9, 4, 1, 0, 1, 4, 9);
	my $actual_pearson = 0;
	my $pearson = &Pearson([@vector_07], [@vector_08]);
	if($actual_pearson == $pearson){
		print"Pearson = $pearson\n\n";
	} else {
		print"Pearson failed\n$actual_pearson != $pearson\n\n";
	}
}

sub test_pearson_2
{
	print"Testing Pearson #2\n";
	my @vector_09 = (-3, 6, 0, 3, -6);
	my @vector_10 = (1, -2, 0, -1, 2);
	my $actual_pearson = -1;
	my $pearson = &Pearson([@vector_09], [@vector_10]);
	if($actual_pearson == $pearson){
		print"Pearson = $pearson\n\n";
	} else {
		print"Pearson failed\n$actual_pearson != $pearson\n\n";
	}
}

sub test_pearson_3
{
	print"Testing Pearson #3\n";
	my @vector_11 = (3, 6, 0, 3, 6);
	my @vector_12 = (1, 2, 0, 1, 2);
	my $actual_pearson = 1;
	my $pearson = &Pearson([@vector_11], [@vector_12]);
	if($actual_pearson == $pearson){
		print"Pearson = $pearson\n\n";
	} else {
		print"Pearson failed\n$actual_pearson != $pearson\n\n";
	}
}

sub test_cosine
{
	print"Testing Cosine\n";
	my @vector_13 = (3, 2, 0, 5, 0, 0, 0, 2, 0, 0);
	my @vector_14 = (1, 0, 0, 0, 0, 0, 0, 1, 0, 2);
	my $actual_cosine = 0.314970394174356;
	my $cosine = &Cosine([@vector_13], [@vector_14]);
	if($actual_cosine == $cosine){
		print"Cosine = $cosine\n\n";
	} else {
		print"Cosine failed!\n$actual_cosine != $cosine\n\n";
	}
}

sub euclideanDistance
{
	my($distRef, $datRef) = @_;
	my @dist = @{$distRef};
	my $distSize = @dist;
	my @dat = @{$datRef};
	my $datSize = @dat;
	
	if($distSize != $datSize){
		print"distSize = $distSize NOT EQUAL datSize = $datSize\n";
		return -1;
	}
	
	my $total = 0;
	for($i = 0; $i < $distSize; $i++){
		my $distElement = $dist[$i];
		my $datElement = $dat[$i];
		
		$total += ($distElement - $datElement) ** 2;
	}
	return $total ** (1/2)
}

sub SMC
{
	my($distRef, $datRef) = @_;
	my @dist = @{$distRef};
	my $distSize = @dist;
	my @dat = @{$datRef};
	my $datSize = @dat;
	
	if($distSize != $datSize){
		print"distSize = $distSize NOT EQUAL datSize = $datSize\n";
		return -1;
	}
	
	my $f_00 = 0;
	my $f_01 = 0;
	my $f_10 = 0;
	my $f_11 = 0;
	for($i = 0; $i < $distSize; $i++){
		my $distElement = $dist[$i];
		my $datElement = $dat[$i];
		
		if($distElement == 0 && $datElement == 0){
			$f_00++;
		}
		if($distElement == 0 && $datElement == 1){
			$f_01++;
		}
		if($distElement == 1 && $datElement == 0){
			$f_10++;
		}
		if($distElement == 1 && $datElement == 1){
			$f_11++;
		}
	}
	
	#print"f_00 = $f_00\n";
	#print"f_01 = $f_01\n";
	#print"f_10 = $f_10\n";
	#print"f_11 = $f_11\n";
	
	return ($f_11 + $f_00)/($f_00 + $f_01 + $f_10 + $f_11);
}

sub jaccard
{
	my($distRef, $datRef) = @_;
	my @dist = @{$distRef};
	my $distSize = @dist;
	my @dat = @{$datRef};
	my $datSize = @dat;
	
	if($distSize != $datSize){
		print"distSize = $distSize NOT EQUAL datSize = $datSize\n";
		return -1;
	}
	
	my $f_00 = 0;
	my $f_01 = 0;
	my $f_10 = 0;
	my $f_11 = 0;
	for($i = 0; $i < $distSize; $i++){
		my $distElement = $dist[$i];
		my $datElement = $dat[$i];
		
		if($distElement == 0 && $datElement == 0){
			$f_00++;
		}
		if($distElement == 0 && $datElement == 1){
			$f_01++;
		}
		if($distElement == 1 && $datElement == 0){
			$f_10++;
		}
		if($distElement == 1 && $datElement == 1){
			$f_11++;
		}
	}
	
	#print"f_00 = $f_00\n";
	#print"f_01 = $f_01\n";
	#print"f_10 = $f_10\n";
	#print"f_11 = $f_11\n";
	
	return $f_11/($f_01 + $f_10 + $f_11);
}

sub Average
{
	my @vector = @_;
	my $vectorSize = @vector;
	my $total = 0;
	foreach my $element (@vector){
		$total += $element;
	}
	return $total/$vectorSize;
}

sub Covariance
{
	my($distRef, $datRef) = @_;
	my @dist = @{$distRef};
	my $distSize = @dist;
	my @dat = @{$datRef};
	my $datSize = @dat;
	
	if($distSize != $datSize){
		print"distSize = $distSize NOT EQUAL datSize = $datSize\n";
		return -1;
	}
	
	my $x_avg = &Average(@dist);
	my $y_avg = &Average(@dat);
	my $total = 0;
	
	for($i = 0; $i< $distSize; $i++){
		$total += ($dist[$i] - $x_avg) * ($dat[$i] - $y_avg)
	}
	
	return $total/($distSize - 1);
}

sub Standard_Deviation
{
	my @vector = @_;
	my $vectorSize = @vector;
	my $vector_avg = &Average(@vector);
	my $total = 0;
	
	foreach my $element (@vector){
		$total += (($element - $vector_avg) ** 2);
	}
	return ($total/($vectorSize - 1)) ** (1/2);
}

sub Pearson
{
	my($distRef, $datRef) = @_;
	my @dist = @{$distRef};
	my $distSize = @dist;
	my @dat = @{$datRef};
	my $datSize = @dat;
	
	if($distSize != $datSize){
		print"distSize = $distSize NOT EQUAL datSize = $datSize\n";
		return -1;
	}
	
	my $covariance = &Covariance($distRef, $datRef);
	my $std_dev_x = &Standard_Deviation(@dist);
	my $std_dev_y = &Standard_Deviation(@dat);
	
	return $covariance/($std_dev_x * $std_dev_y);
	
}
sub Dot_Product
{
	my($distRef, $datRef) = @_;
	my @dist = @{$distRef};
	my $distSize = @dist;
	my @dat = @{$datRef};
	my $datSize = @dat;
	
	if($distSize != $datSize){
		print"distSize = $distSize NOT EQUAL datSize = $datSize\n";
		return -1;
	}
	
	my $total = 0;
	for($i = 0; $i< $distSize; $i++){
		$total += $dist[$i] * $dat[$i];
	}
	return $total;
}

sub Vector_Length
{
	my @vector = @_;
	my $dot_vector = &Dot_Product([@vector], [@vector]);
	return $dot_vector ** (1/2);
}
sub Cosine
{
	my($distRef, $datRef) = @_;
	my @dist = @{$distRef};
	my $distSize = @dist;
	my @dat = @{$datRef};
	my $datSize = @dat;
	
	if($distSize != $datSize){
		print"distSize = $distSize NOT EQUAL datSize = $datSize\n";
		return -1;
	}
	
	my $dot_prod = &Dot_Product($distRef, $datRef);
	my $x_length = &Vector_Length(@dist);
	my $y_length = &Vector_Length(@dat);
	
	return $dot_prod/($x_length*$y_length);
}
