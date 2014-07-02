<?php
 // record client screen dimensions
include ('counter_config.php');

if (isset($_GET["w"]) && isset($_GET["h"])) 
{
  $width = $_GET["w"];
  $height = $_GET["h"];
  if (is_numeric($width) && is_numeric($height))
  {
    $resolution = $width . 'x' . $height;
    // connect + select  database
    $mysqli = new mysqli($localhost, $dbuser, $dbpass, $dbname);
    if ($mysqli->connect_errno)
    { //die("Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
      error_log("Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error, 0);
      exit;  // no point in continuing
    }
    //update/insert screen
    mysqli_query($mysqli, "UPDATE $dbtablescreen SET count = count + 1 WHERE resolution = '$resolution'"); 
    $rows = mysqli_affected_rows($mysqli);
    // if resolution didnt exist yet, then insert it
    if ($rows == 0)
    {
      mysqli_query($mysqli, "INSERT INTO $dbtablescreen(resolution, count) VALUES('$resolution', 1)");
      if (mysqli_affected_rows($mysqli) == 0)
      { //die ("Can\'t insert into $dbtablescreen : " . mysqli_error($mysqli));
        error_log("$dbtablescreen INSERT failed : " . mysqli_error($mysqli), 0);
      }
    } 
    mysqli_close($mysqli);
  }
}
?>