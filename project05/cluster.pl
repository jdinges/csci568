#!/usr/bin/perl

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
	&sortCSV([@contents]);
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
	
	foreach my $line (@array) {
		if($line=~/\w+/){
			my @attributes = split(/,/,$line);
			my $attributeSize = @attributes;
			print"$attributeSize\n";
		}
		
	}
}