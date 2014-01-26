#!/usr/bin/perl

use warnings;
use strict;

#use Text::vFile;

#use Text::vCard;

#contactid	firstname	middlename	lastname	address1	address2	city	state	country	postcode	homephone	cellphone	email	altemail	maidenname	workphone	comment	birthdate	nickname	salutation	aimicqim	yahooim	googleim	otherim
#1	Joe	NULL	Contactsworth	111 P St. #31337	NULL	Atlanta	GA	NULL	30316	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL

my %addressHash;

while(<STDIN>)
{
	next if /^#/;
	chomp;
	my ($uid, $fn, undef, $ln, $a1, $a2, $cy, $st, $country, $pc, undef, undef, undef, undef, undef, undef, undef, undef, undef, undef, undef, undef, undef, undef, $shouldCard) = split /\t/;
	next unless $shouldCard == 1;

	if (exists $addressHash{$a1})
	{
		if ($addressHash{$a1}[1] eq 'Family')
		{
			if($addressHash{$a1}[0] =~ /$ln/)
			{
				next; #family name already accounted for
			}
			else
			{
				$addressHash{$a1}[0] .= " / $ln"; #hippie-chick
			}
		}
		else #initiate new family
		{
			if(($ln ne '') and ($addressHash{$a1}[1] =~ /$ln/))
			{
				$addressHash{$a1}[1] = 'Family';
				$addressHash{$a1}[0] = "The $ln";
			}
			else #hippie chick
			{
				$addressHash{$a1}[0] = "The $ln / ".$addressHash{$a1}[1];
				$addressHash{$a1}[1] = 'Family';
			}
		}
	}
	else #new address
	{
		$addressHash{$a1} = [$fn, $ln, $a2, $cy, $st, $country, $pc];
	}
}

#BEGIN:VCARD
#VERSION:3.0
#N:Conrad;Jason;;;
#FN:Jason Conrad
#ADR;type=HOME:a1;a2;;c1;s1;p1;
#END:VCARD
#BEGIN:VCARD
#VERSION:3.0
#N:Conrad;Jill;;;
#FN:Jill Conrad
#ADR;type=HOME:;a1;;a2;c1;s1;
#END:VCARD


foreach my $key (keys %addressHash)
{
	print "BEGIN:VCARD\nVERSION:3.0\n";
	print 'N:'.$addressHash{$key}[1].';'.$addressHash{$key}[0].";;;\n";
	print 'FN:'.$addressHash{$key}[0].' '.$addressHash{$key}[1]."\n";
	print 'ADR;type=HOME:;;'.$key.
	      ($addressHash{$key}[2] eq "\\N" ? '' : ' '.$addressHash{$key}[2]).';'.
	      $addressHash{$key}[3].';'.$addressHash{$key}[4].';'.
	      $addressHash{$key}[6].";\n";
	print "END:VCARD\n";
}
