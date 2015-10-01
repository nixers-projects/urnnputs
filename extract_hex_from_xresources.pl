#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

extract_hex_from_xresources.cpp

Usage ./extract_hex_from_xresources.pl [xresources file]

Extracts the hex codes from the .Xresources one per line and always in the same order

prefixes colors with color index value:

*.color1:       #aa4450
	==>
*.color1: #aa4450


=cut


sub HELP {
	print "Usage $0 \t [xresources file]\n"
	."Extracts the hex codes from the .Xresources one per line and always in the same order.\n"
	."Use -s as a file for stdin\n";
	exit;
}


my @COLORS;
my %COLORS_INDEXES = (
	background => 0,
	foreground => 1,
	color0 => 2,
	color1 => 3,
	color2 => 4,
	color3 => 5,
	color4 => 6,
	color5 => 7,
	color6 => 8,
	color7 => 9,
	color8 => 10,
	color9 => 11,
	color10 => 12,
	color11 => 13,
	color12 => 14,
	color13 => 15,
	color14 => 16,
	color15 => 17
);

my @COLORS_ORDER = qw(
	background
	foreground
	color0
	color1
	color2
	color3
	color4
	color5
	color6
	color7
	color8
	color9
	color10
	color11
	color12
	color13
	color14
	color15
);

sub extract_hex {
	my ($source) = @_;
	my $fh;
	if ($source eq '-s') {
		$fh = \*stdin;
	}
	else {
		open($fh, "<", $source) or die "$!";
	}
	while (<$fh>) {
		for my $i (keys %COLORS_INDEXES) {
			if (/$i\s*:/) {
				chomp;
				$_ =~ /(#[\da-f]{6})/i;
				$COLORS[$COLORS_INDEXES{$i}] = lc($1);
			}
		}
	}
	#print "$_\n" for (values %COLORS_INDEXES);
	foreach my $i (0 .. $#COLORS_ORDER) {
		print "*.$COLORS_ORDER[$i]: $COLORS[$i]\n";
	}
}


sub main {
	my $resource_file = shift @ARGV;
	HELP if (!$resource_file);
	extract_hex($resource_file);
}


main;
