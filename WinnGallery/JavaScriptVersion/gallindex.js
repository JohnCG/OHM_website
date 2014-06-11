"use strict";
var nTimer;          // global timer ID
var nSlideCount = 1; // global slide index for slide show
var bTimerOn = false;

function showBigPicture(sPathToNormalImage, sPathToFullsizeImage, sCaption)
{  
  console.log('entered showBigPicture: sPathToNormalImage= ' + sPathToNormalImage + ' sPathToFullsizeImage= ' + sPathToFullsizeImage);
  //var indx = sPathToNormalImage.lastIndexOf('\\');
  //console.log('indx=' + indx);
  //var str = sPathToNormalImage.substr(indx + 1);
  //console.log('substr=' + str);

  //var x = document.getElementById("galleryBigPane").innerHTML='<a href="#" onmousedown="showFullsizeImage(\'' + sPathToFullsizeImage + '\');"><img src="' + sPathToNormalImage + '" id="eachBigPicture"/><p>' + sCaption + '</p></a>';
var x = document.getElementById("galleryBigPane").innerHTML='<a href="' + sPathToFullsizeImage + '" target="_blank"><img src="' + sPathToNormalImage + '" id="eachBigPicture"/><p>' + sCaption + '</p></a>';
}

function showFullsizeImage(sPathToFullsizeImage)
{
  console.log('entered showFullsize: sPathToFullsizeImage= ' + sPathToFullsizeImage);
  if (bTimerOn)
  {
    clearInterval(nTimer);
    bTimerOn = false;
  }
  //var w = window.open('\''+ sPathToFullsizeImage + '\'');
var w = window.open(".\largeimages\DrGordons.jpg");
}

function doSlideShow(nIndex)
{ //until the user clicks something
  console.log('entered doSlideShow nIndex = ' + nIndex);
  if (nIndex > 31)
    nIndex = 0;
  showBigPicture(nIndex++);
}

function userClickedThumbnail(sPathToNormalImage, sPathToFullsizeImage, sCaption)
{
  console.log('userClickedThumbnail entered: sPathToNormalImage= ' + sPathToNormalImage + 'sPathToFullsizeImage= ' + sPathToFullsizeImage);
  if (bTimerOn)
  {
    clearInterval(nTimer);
    bTimerOn = false;
  }
  showBigPicture(sPathToNormalImage, sPathToFullsizeImage, sCaption);
}