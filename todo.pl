#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;
use Getopt::Long;

use Env qw(HOME);
my $TODO_PATH = "$ENV{HOME}/TODO";

use POSIX qw(strftime);
my $DATE = strftime "%F", localtime();

#       # [ ] no completed
#       # [-] postponed
#       # [+] delegated
#       # [x] completed

sub newday {
	# variables
	my $LASTFILE=`ls -t1 $TODO_PATH | head -n1`;
	$LASTFILE="$TODO_PATH/$LASTFILE";
	my $NEWFILE = "$TODO_PATH/$DATE";

	# hack to bomb out instead of overwriting our NEWFILE.
	# this whole method should be modified to do Perl inline writing.
	# it should also abstract the "add checkboxes" so todo() can reuse.
	chomp($LASTFILE);
	chomp($NEWFILE);

	if ($LASTFILE eq $NEWFILE) {
		return 0
	}

	open(OUTFILE, ">$NEWFILE");
	open(INFILE, "<$LASTFILE");
	while(<INFILE>)
	{
		my($line) = $_;

		chomp($line);

		# skip blank lines
		if ($line =~ /^\s*$/) {
			next;
		}

		# add checkboxes to lines without one
		if ($line =~ /^[^\[]/) {
			print OUTFILE "[ ] $line\n";
			next;
		}

		# remove "completed" items
		if ($line =~ /^\[x\]/) {
			next;

		}

		# decrement "postponed" flag
		if ($line =~ /^\[(-+)] (.*)$/) {
			my $postponed_days = substr($1, 0, -1);

			if (length $postponed_days > 0) {
				print OUTFILE "[$postponed_days] $2\n";
			}
			else {
				print OUTFILE "[ ] $2\n";
			}
			next;
		}

		print OUTFILE "$line\n";

	}
}

sub todo {
	print `sed --in-place -e 's/^\\([^\[]\\)/[ ] \\1/' $TODO_PATH/$DATE `;
	exec "vim $TODO_PATH/$DATE";
}

my $_name = basename($0);

if ($_name eq 'todo')
{
	todo
}

if ($_name eq 'newday')
{
	newday
}
