#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;
use File::Copy;
use Getopt::Long;

use Env qw(HOME);
my $TODO_PATH = "$ENV{HOME}/TODO";

use POSIX qw(strftime);
my $DATE = strftime "%F", localtime();

my $FILE= "$TODO_PATH/$DATE";

my $help = 0;
my $newday = 0;
my $refresh = 0;

my $result = GetOptions("help"    => \$help,
                        "newday"  => \$newday,
                        "refresh" => \$refresh,);

if ($help) {
	printf("TODO list syntax:\n");
	printf("\t[ ] not completed: item will be left unmodified after subsequent runs\n");
	printf("\t[-] postponed: postponement counter (-) will be decremented daily, supports multiple day postponements\n");
	printf("\t[+] delegated: nothing will happen. can be postponed (-+) to remind you to follow up.\n");
	printf("\t[x] completed: line will be deleted when run with --newday or --refresh\n");
	exit 0;
}

sub remove_blank_lines {
	local $^I = ".bak";
	local @ARGV = $FILE;

	while(<>)
	{
		my($line) = $_;

		chomp($line);

		# skip blank lines
		if ($line =~ /^\s*$/) {
			next;
		}

		print "$line\n";
	}
}

sub add_checkboxes {
	local $^I = ".bak";
	local @ARGV = $FILE;

	while(<>)
	{
		my($line) = $_;

		chomp($line);

		# add checkboxes to lines without one
		if ($line =~ /^[^\[]/) {
			print "[ ] $line\n";
			next;
		}

		print "$line\n";
	}
}

sub remove_completed {
	local $^I = ".bak";
	local @ARGV = $FILE;

	while(<>)
	{
		my($line) = $_;

		chomp($line);

		# remove "completed" items
		if ($line =~ /^\[x\]/) {
			next;

		}

		print "$line\n";
	}
}

sub decrement_postponed {
	local $^I = ".bak";
	local @ARGV = $FILE;

	while(<>)
	{
		my($line) = $_;

		chomp($line);

		# decrement "postponed" flag
		if ($line =~ /^\[(-+)] (.*)$/) {
			my $postponed_days = substr($1, 0, -1);

			if (length $postponed_days > 0) {
				print "[$postponed_days] $2\n";
			}
			else {
				print "[ ] $2\n";
			}
			next;
		}

		print "$line\n";
	}
}

my $_name = basename($0);

if ($_name eq 'todo')
{
	remove_blank_lines;
	add_checkboxes;
	if ($refresh) {
		remove_completed;
	}

	exec "vim $TODO_PATH/$DATE";
}

if ($_name eq 'newday')
{
	# variables
	my $LASTFILE=`ls -t1 $TODO_PATH | head -n1`;
	$LASTFILE="$TODO_PATH/$LASTFILE";

	# hack to bomb out instead of overwriting our NEWFILE.
	# this whole method should be modified to do Perl inline writing.
	# it should also abstract the "add checkboxes" so todo() can reuse.
	# in this re-factored version using copy(), this may not be needed.
	chomp($LASTFILE);
	chomp($NEWFILE);

	if ($LASTFILE eq $NEWFILE) {
		return 0
	}

	open(OUTFILE, ">$NEWFILE");

	copy($LASTFILE, $FILE);

	remove_blank_lines;
	add_checkboxes;
	remove_completed;
	decrement_postponed;
}
