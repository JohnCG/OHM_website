#!/usr/bin/perl -w
# program to preprocess HTML files inserting text where indicated
# 
# How to use the feature:
# in your HTML files, put <!-- #INCLUDE_START somefilename.txt -->
#                         <!-- #INCLUDE_END somefilename.txt -->
#
# this program looks for a text file named somefilename.txt and pastes its contents between the above markers
# (deleting any text already there).
#
# INPUTS:
#          directory path to search for .html files and text files to include   - htmlDirPath
#            (must be in same directory)
#
# RETURNS: 
#          0 on success else some error
#

use strict;
use warnings;

(my $second, my $minute, my $hour, my $dayofmonth, my $month, my $year, my $weekday, my $dayofyear, my $isdst) = localtime(time);
my $now = sprintf('%02d_%02d_%02d_%02d_%02d_%02d', $year + 1900,  $month + 1, $dayofmonth, $hour, $minute, $second);
print "now = $now \n";
#user must provide directory name or "." (-1 indicates no input)
unless($#ARGV == 0) {die "directory name required (use . for current directory)\n";}

# read in the target html directory path that the user provided
my $HtmlDir = shift;
print '$HtmlDir is ' .$HtmlDir . "\n";
opendir(DIR, "$HtmlDir") || die "can't open $HtmlDir\n";

# create a list of all .html files in that directory
my @Files = grep(/\.html$/,readdir(DIR)) or die "no html files found\n";
closedir(DIR);

print "number of found files is: " .($#Files +1). "\n";
chdir($HtmlDir) or die "can't change directory to $HtmlDir\n";
foreach my $File (@Files) {
  print "found file $File\n";
  my $OldFile = $File.$now;
  # rename input so we can create output file with that name
  rename($File, $OldFile) or die "can't rename $File to $OldFile\n";
  open(my $hOldHtmlFile, '<', $OldFile) or die "can't open file $OldFile\n";
  open(my $hNewHtmlFile, '>', $File) or die "can't open file $File\n";
  while(<$hOldHtmlFile>) {
    my $ThisLine = $_;
    ###print "line=$ThisLine";
    # if the line is not a marker then just copy it
    unless ($ThisLine =~ m/<!-- #INCLUDE_START/) {print $hNewHtmlFile $ThisLine; next;};
    print $hNewHtmlFile $ThisLine; # copy start marker
    # found the START marker, now parse off the name (= name of the text file to include)
#find out the starting column - may not be first column - could be indented!
my $StartCol = index($ThisLine, '<!-- #INCLUDE_START ');
print "startcol is $StartCol\n";
#    my $TextFile = substr($ThisLine,length('<!-- #INCLUDE_START '));
my $TextFile = substr($ThisLine,$StartCol + length('<!-- #INCLUDE_START '));
 print "substr1 TEXTFILE=$TextFile\n";
    my $indx = index($TextFile,' -->',0);
    ###print "indx = $indx\n";
    $TextFile = substr($TextFile,0,$indx);
    ###print "substr2  TEXTFILE=$TextFile\n";

    # ignore old included text until END marker found
    while(<$hOldHtmlFile>) {
        $ThisLine = $_;
        ###print "ignoring $ThisLine";
        unless ($ThisLine =~ m/<!-- #INCLUDE_END/) {next;};
        # found the END marker, now copy in text to be included
        open(my $hTextFile, '<', $TextFile) or die "can't open include file $TextFile\n";
        while(<$hTextFile>) {
            my $IncludeLine = $_;
            ###print "including $IncludeLine";
            print $hNewHtmlFile $IncludeLine;
            }
        close($hTextFile);
        # now copy the END marker to the new html file
        print $hNewHtmlFile $ThisLine;
        last;
        }
    }
    close($hNewHtmlFile);
    close($hOldHtmlFile);
    print "File $File completed\n";
}
print "Success!\n";
exit 0;