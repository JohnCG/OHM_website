<?php
// collect some statistics
include ('counter_config.php');

function collectStats()
{ // connect + select  database
  $agent =$_SERVER["HTTP_USER_AGENT"];
  date_default_timezone_set("America/New_York");
  $today = date("Y-m-d");
  global $localhost, $dbuser, $dbpass, $dbname, $dbtableagents, $dbtabledays, $dbtablescreen;
  $mysqli = new mysqli($localhost, $dbuser, $dbpass, $dbname);
  if ($mysqli->connect_errno)
  { //die("Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
    error_log("Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error, 0);
    exit;  // no point in continuing
  }
  //update/insert agents
  mysqli_query($mysqli, "UPDATE $dbtableagents SET count = count + 1 WHERE agent = '$agent'"); 
  $rows = mysqli_affected_rows($mysqli);
  // if agent didnt exist yet, then insert it
  if ($rows == 0)
  {
    mysqli_query($mysqli, "INSERT INTO $dbtableagents(agent, count) VALUES('$agent', 1)");
    if (mysqli_affected_rows($mysqli) == 0)
    { //die ("Can\'t insert into $dbtableagents : " . mysqli_error($mysqli));
      error_log("$dbtableagents INSERT failed : " . mysqli_error($mysqli), 0);
    }
  }
  // check if day exists and insert/update 
  mysqli_query($mysqli, "UPDATE $dbtabledays SET count = count + 1 WHERE day = '$today'");
  $rows = mysqli_affected_rows($mysqli);
  if ($rows == 0) // if day didnt exist yet, then insert it
  {
    mysqli_query($mysqli, "INSERT INTO $dbtabledays(day, count) VALUES('$today', 1)");
    if (mysqli_affected_rows($mysqli) == 0)
    { //die ("Can\'t insert into $dbtabledays : " . mysqli_error($mysqli));
      error_log("$dbtabledays INSERT failed : " . mysqli_error($mysqli), 0);    
    }
  }
  mysqli_close($mysqli);
}
?>
