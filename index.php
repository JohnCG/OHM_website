<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><title>OGUNQUIT HERITAGE MUSEUM</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
  <link href="HomeStyle.css" rel="stylesheet" type="text/css"/>
   <?php require 'counter.php'; collectStats(); ?>
  <script type="text/javascript">
    "use strict";
    // attempt to record clients screen dimensions
    var nScreenWidth = window.screen.availWidth;
    var nScreenHeight = window.screen.availHeight;
    var xmlhttp = null;
    if (window.XMLHttpRequest){ xmlhttp = new XMLHttpRequest();}
    else { xmlhttp = new XMLHttpRequest("Microsoft.XMLHTTP");}
    xmlhttp.open("GET", "screen.php?w=" + encodeURIComponent(nScreenWidth) + "&h=" + encodeURIComponent(nScreenHeight), false);
    xmlhttp.send();
  </script>
</head>
<body id="body">
<h1>THE OGUNQUIT HERITAGE MUSEUM</h1>
<h2><span style="font-style: italic;">at the </span>CAPTAIN JAMES WINN HOUSE</h2>

<div id="maincontainer">
   <?php require 'navigationButtons.php';?>

<div id="center">
<img src="pics/WinnHouseNew.jpg" style="width: 565px; height: 410px;" alt="picture of the Winn House"/>
</div>

</div>

<div id="bottom">
<br/>
Ogunquit Heritage Museum<br/>
86 Obeds Lane<br/>
Ogunquit, Maine 03907<br/>
207&#8211;646&#8211;0296<br/>
Free and Open to the public<br/>
1 &#8211; 5 P.M., Tuesday &#8211; Saturday<br/>
June through September<br/>
Contact us at:<br/>
<a href="mailto:info@ogunquitheritagemuseum.org">info@ogunquitheritagemuseum.org</a><br/>
<br/>
</div>
</body></html>
