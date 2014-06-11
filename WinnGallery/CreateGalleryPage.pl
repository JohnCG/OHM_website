#!/usr/bin/perl -w
# program to create a photo gallery web page
#
# input is a comma delimited file in the format:
# imageName,tooltip,caption
#      where imageName is the filename of the photo, i.e. 'Aphoto.jpg'
#            tooltip   is the short description to pop up over a thumbnail, i.e. 'photo desc'
#            caption   is the long description for a normal sized photo, i.e. 'This is a long photo description'
#            
#
# INPUT: filename containing the above (assumed to be in the current directory)
#
# OUTPUT: filename.html
#
# RETURNS: 
#          0 on success else some error
#

use strict;
use warnings;
use Cwd;

my $sPathToNormalImage    = './images/';
my $sPathToThumbnailImage = './thumbnails/';
my $sPathToFullsizeImage  = './largeimages/';
my $sPathToPages          = './pages/';


sub generateIndividualPage($$$$$$) {

my $sgipImageName = shift;
my $sgipCaption = shift;
my $sgipPathToNormalImage = shift;
my $sgipPathToFullsizeImage = shift;
my $sgipPathToPages = shift; 
my $sgipPageName = shift;

my $sIndividualPageFile = $sgipPageName.'.htm';
###print(cwd);
#CD to put these pages in a separate directory
chdir("$sgipPathToPages") or die "can't CD to directory $sgipPathToPages\n";
open(my $hIndividualPageFile, '>', $sIndividualPageFile) or die "can't open individual page file $sIndividualPageFile\n";
#write the header to the new page
print $hIndividualPageFile <<'INDIVHEAD';
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="content-type" content="text/html;charset=iso-8859-1">
  <title>MuseumPhoto</title>
  <link href="../images/galleryStyle.css" rel="stylesheet" type="text/css">
</head>

<body id="eachBigPicturePageBody">
INDIVHEAD
#format of line generated below
#<a href="../largeimages/PerkinsCove1940.jpg" target="_blank"><img src="../images/PerkinsCove1940.jpg" alt="Perkins Cove circa 1940"><p>Perkins Cove (circa 1940)</p></a>
print $hIndividualPageFile "  <a href=\"\.$sgipPathToFullsizeImage$sgipImageName\" target=\"_blank\"><img src=\"\.$sgipPathToNormalImage$sgipImageName\" alt=\"$sgipCaption\"><p>$sgipCaption</p></a>\n";
print $hIndividualPageFile "</body>\n";
print $hIndividualPageFile "</html>\n";
close($hIndividualPageFile);
#restore current directory for return
chdir("..") or die "can't CD UP\n";
}



# read in the target filename that the user provided
my $TextFile = shift;
###print '$TextFile is ' .$TextFile ."\n";
open(my $hTextFile, '<', $TextFile) or die "can't open file $TextFile\n";

#get the filename without the extension
my @Filename = split(/\./, $TextFile);
###print "fn WO ext= $Filename[0]\n";
my $sGalleryMainPageHTMLFile = $Filename[0].'.html';
open(my $hGalleryMainPageHTMLFile, '>', $sGalleryMainPageHTMLFile) or die "can't open file $sGalleryMainPageHTMLFile\n";

#write the header info to the html file
print $hGalleryMainPageHTMLFile <<'HEAD';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Heritage Museum Photo Gallery</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
 <link href="images/galleryStyle.css" rel="stylesheet" type="text/css"/> 
<!--[if (IE)&(lt IE 9)&(!WindowsEdition)]><link href="images/galleryStyleIE8XP.css" rel="stylesheet" type="text/css"/><![endif]-->
</head>

<body id="galleryPageMainBody">
<div id="galleryCenteredWrapper"> 
<!-- <div class="info"><a href="http://www.ogunquitheritagemuseum.org/">Return to Heritage Museum</a></div> -->
<a id="returnFromGallery" href="../index.html">Return&nbsp;to&nbsp;Heritage&nbsp;Museum</a>
     
<h1>HERITAGE&nbsp;MUSEUM&nbsp;PHOTO&nbsp;GALLERY</h1>

HEAD

#create the page body and individual pages
my $sFirstPage = '';
my $nCount1Based = 0;
my $nRowCount = 1;
while(<$hTextFile>) {
    my $ThisLine = $_;
    ###print "line=$ThisLine\n";
    chomp($ThisLine);
    my @TheStrings = split(/,/, $ThisLine);
    ###print "TheStrings= @TheStrings\n";
    my $sImageName = $TheStrings[0];
    my $sToolTip = $TheStrings[1];
    my $sCaption = $TheStrings[2];
    #separate filename from extension for use as page name
    my @ImageNameStrings = split(/\./, $sImageName);
    my $sPageName = $ImageNameStrings[0];
    if ($nCount1Based == 0) {$sFirstPage = $sPageName};  #remember for footer below   
    if ($nCount1Based == 0 || ($nCount1Based %10 == 0)) {
      if ($nCount1Based != 0) {
        print $hGalleryMainPageHTMLFile "</div>\n";
      }
      print $hGalleryMainPageHTMLFile "<div id=\"tnrow$nRowCount\">\n";
      $nRowCount++;
    }
    $nCount1Based++;
    #format of line generated below
    #<a id="tn1" class="thumbnailAndCaption" href="./pages/AerialViewOfOgunquit1930.htm" target="TopFrame"><img src="./thumbnails/AerialViewOfOgunquit1930.jpg" alt="Aerial View"/><span>Aerial View</span></a>
    print $hGalleryMainPageHTMLFile "  <a id=\"tn$nCount1Based\" class=\"thumbnailAndCaption\" href=\"$sPathToPages$sPageName.htm\" target=\"TopFrame\"><img src=\"$sPathToThumbnailImage$sImageName\" alt=\"$sToolTip\"/><span>$sToolTip</span></a>\n";

    #the top and bottom rows of thumbnails are OK as is.  The other rows need a real thumbnail at each end of the row and filler in between.
    if ($nRowCount >= 3 && $nRowCount <= 8 && $nCount1Based %10 == 1) {
      for(my $i=0; $i<8; $i++) {
        $nCount1Based++;
        print $hGalleryMainPageHTMLFile "  <a id=\"tn$nCount1Based\" class=\"thumbnailAndCaption\" href=\"$sPathToPages$sPageName.htm\" target=\"TopFrame\"><img src=\"$sPathToThumbnailImage$sImageName\" alt=\"$sToolTip\"/><span>$sToolTip</span></a>\n";
      }
    }
    #now generate an individual page for the frame
    generateIndividualPage($sImageName,$sCaption,$sPathToNormalImage,$sPathToFullsizeImage,$sPathToPages,$sPageName);
    
    }
close($hTextFile);

# write the footer to the html file
print $hGalleryMainPageHTMLFile "</div>\n";
print $hGalleryMainPageHTMLFile "\n<!-- the big image gets displayed here -->\n";
print $hGalleryMainPageHTMLFile "<iframe id=\"TopFrame\" name=\"TopFrame\" src=\"$sPathToPages$sFirstPage.htm\"> Your browser does not support iframes TOPFRAME. </iframe>\n";
print $hGalleryMainPageHTMLFile "</div> <!-- end galleryCenteredWrapper -->\n";
print $hGalleryMainPageHTMLFile "</body></html>\n";
print "Success\n";
exit 0;

