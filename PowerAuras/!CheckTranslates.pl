#!/usr/bin/perl -w
use strict;

# THIS IS ONE UGLY DIRTY HACK to check the translation file of
# PowerAuras for missing/unneeded/etc. translations.
#
# Copyright (C) 2013  Christian Garbs <mitch@cgarbs.de>
# Licensed under GNU GPL v3 or later.
#
#
# The script works by trying to parse the LUA file and thus is
# propably full of bugs - it would be better to just write it
# in LUA and directly check the arrays…
#
# Called with no commandline arguments, it will check all
# languages and print a summary.
#
# Called with a language, it will print detailed information
# for that language.

#[ read ]###########################################################

my %s;
my $lang = '';
my $prefix = '';
my $suffix = '';
my $tmp;

open LUA, '<', 'PowerAurasLocalizations.lua' or die $!;

while (my $line = <LUA>) {

    chomp $line;
    $line =~ s/\r$//;
    
    if ($line =~ /GetLocale\(\)\s*==\s*"([^"]+)"/) {
	$lang = $1;
	$tmp = undef;
	$prefix = $suffix = '';

    }
    elsif ($line =~ /^\W*?([-a-z._0-9[\]]+)\s*=\s*"([^"]*)"\s*,?\s*$/i) {
	$s{$lang}->{"${prefix}${1}${suffix}"} = $2;
	$tmp = undef;
    }
    elsif ($line =~ /^\s*([a-z._0-9[\]]+)\s*=\s*\{\s*$/i) {
	$prefix = $1.' { ';
	$suffix = ' }';
	$tmp = undef;
    }
    elsif ($line =~ /^\s*([a-z._0-9[\]]+)\s*=\s*$/i) {
	$tmp = $1;
    }
    elsif ($line =~ /^\s*\{\s*$/) {
	next unless defined $tmp;
	$prefix = $tmp.' { ';
	$suffix = ' }';
	$tmp = undef;
    }
    elsif ($line =~ /^\s*\}\s*,?\s*$/) {
	next unless length $prefix;
	$prefix = $suffix = '';
	$tmp = undef;
    }

}

close LUA or die $!;

my @lang = sort grep {/./} keys %s;
printf "\nlanguages found: %s\n", join(', ', @lang);

#[ write single language ]##########################################

if (defined $ARGV[0]) {

    my $l = $ARGV[0];

    die "ERROR: language <$l> does not exist\n" unless grep {/^$l$/} @lang;

    print "\n\n LANGUAGE $l:\n ~~~~~~~~~~~~~~\n\n";

    print "\n ==== missing translations ====\n\n";
    $prefix = undef;
    $tmp = undef;
    foreach my $k (sort {
	(($b =~ /^[^ ]+ { [^} ]+ }/)
	 <=> 
	 ($a =~ /^[^ ]+ { [^} ]+ }/))
	    ||
	    $a cmp $b
		   }
		   keys %{$s{''}}) {
	unless (exists $s{$l}->{$k}) {
	    if ($k =~ /^([^ ]+) { ([^} ]+) }/) {
		$tmp = $2;
		if (not (defined $prefix and $prefix eq $1)) {
		    if (defined $prefix) {
			print "},\n";
		    }
		    $prefix = $1;
		    print "\n$prefix =\n{\n";
		}
		print "\t";
	    }
	    else {
		if (defined $prefix) {
		    $prefix = undef;
		    print "},\n\n";
		}
		$tmp = $k;
	    }
	    print "$tmp = \"$s{''}->{$k}\",\n" 
	}
    }

    print "\n ==== unneeded translations ====\n\n";
    foreach my $k (sort keys %{$s{$l}}) {
	print "$k\n" unless exists $s{''}->{$k};
    }

    print "\n ==== empty translations ====\n\n";
    foreach my $k (sort keys %{$s{$l}}) {
	print "$k\n" unless length $s{$l}->{$k};
    }

    print "\n ==== unchanged translations (could be OK, consider this warnings only) ====\n\n";
    foreach my $k (sort keys %{$s{$l}}) {
	print "$k\n" if exists $s{''}->{$k} and $s{$l}->{$k} eq $s{''}->{$k};
    }
}

#[ check all languages ]############################################

else {

    foreach my $l (@lang) {
	print "\nlanguage $l:\n";

	my $n = 0;
	foreach my $k (sort keys %{$s{''}}) {
	    $n++ unless exists $s{$l}->{$k}
	}
	printf "%5d missing translations\n", $n;
	
	$n = 0;
	foreach my $k (sort keys %{$s{$l}}) {
	    $n++ unless exists $s{''}->{$k};
	}
	printf "%5d unneeded translations\n", $n;
	    
	$n = 0;
	foreach my $k (sort keys %{$s{$l}}) {
		$n++ unless length $s{$l}->{$k};
	}
	printf "%5d empty translations\n", $n;
	
	$n = 0;
	foreach my $k (sort keys %{$s{$l}}) {
	    $n++ if exists $s{''}->{$k} and $s{$l}->{$k} eq $s{''}->{$k};
	}
	printf "%5d unchanged translations\n", $n;
    }
}

print "\n";

# wait for enter - but only under Windows
if ($^O eq 'MSWin32') {
    <STDIN>;
}
