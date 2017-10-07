<?php
/**
 * Created by PhpStorm.
 * User: wei
 * Date: 9/18/17
 * Time: 11:03 AM
 */

require('../Server/info.php');
$func = filter_var($_GET["func"]);

switch ($func) {
    case "register":
        $userName = filter_var($_GET["para1"]);
        $realName = filter_var($_GET["para2"]);
        $pw = filter_var($_GET["para3"]);
        $c1Name = filter_var($_GET["para4"]);
        $c1Email = filter_var($_GET["para5"]);
        $c2Name = filter_var($_GET["para6"]);
        $c2Email = filter_var($_GET["para7"]);
        register($userName,$realName, $pw,$c1Name,$c1Email,$c2Name,$c2Email);
        break;
    case "login":
        $userName = filter_var($_GET["para1"]);
        $pw = filter_var($_GET["para2"]);
        login($userName,$pw);
        break;
    case "newTask":
        $StartTime = filter_var($_GET["para1"]);
        $EndTime = filter_var($_GET["para2"]);
        $StartPointX = filter_var($_GET["para3"]);
        $StartPointY = filter_var($_GET["para4"]);
        $TerminalPointX = filter_var($_GET["para5"]);
        $TerminalPointY = filter_var($_GET["para6"]);
        $LastPointX = filter_var($_GET["para7"]);
        $LastPointY = filter_var($_GET["para8"]);
        $LastUpdateTime = filter_var($_GET["para9"]);
        $UserID = filter_var($_GET["para10"]);
        newTask($StartTime, $EndTime, $StartPointX, $StartPointY, $TerminalPointX,
        $TerminalPointY, $LastPointX, $LastPointY, $LastUpdateTime, $UserID);
        break;
    case "cancelTask":
        $UserID = filter_var($_GET["para1"]);
        cancelTask($UserID);
        break;
    case "updateContacts":
        $UserID = filter_var($_GET["para1"]);
        $c1Name = filter_var($_GET["para2"]);
        $c1Email = filter_var($_GET["para3"]);
        $c2Name = filter_var($_GET["para4"]);
        $c2Email = filter_var($_GET["para5"]);
        updateContacts($UserID,$c1Name,$c1Email,$c2Name,$c2Email);
        break;
    case "getContacts":
        $UserID = filter_var($_GET["para1"]);
        getContacts($UserID);
        break;
    case "updateLocation":
        $UserID = filter_var($_GET["para1"]);
        $LastPointX = filter_var($_GET["para2"]);
        $LastPointY = filter_var($_GET["para3"]);
        $LastUpdateTime = filter_var($_GET["para4"]);
        updateLocation($UserID,$LastPointX,$LastPointY,$LastUpdateTime);
        break;
}

//Create an short connection to the database.
function connectDB()
{
    $dbc = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
    return $dbc;
}

//This function is used to create new user.
function register($userName,$realName, $pw,$c1Name,$c1Email,$c2Name,$c2Email){
    $conn = connectDB();
    $checkSQL = "SELECT UserID From User WHERE UserName = '".$userName."';";
    $checkResult = $conn->query($checkSQL);
    $duplicate = $checkResult->num_rows;
    if (!$duplicate){
        $registerSQL="INSERT INTO User (userName, RealName, userPW, C1Name,C1Email,C2Name,C2Email) VALUES ('".$userName."','".$realName."','".$pw."','".$c1Name."','".$c1Email."','".$c2Name."','".$c2Email."');";
        $conn->query($registerSQL);
        $getIDSQL = "SELECT UserID FROM User WHERE UserName = '".$userName."';";
        $result = $conn->query($getIDSQL);
        $row = $result->fetch_assoc();
        $userID= $row["UserID"];
        $result = $userID;
    }else{
        $result = "False";
    }
    $conn->close();
    echo $result;
}

//This function is used to verify if the user is valid.
function login($userName,$pw){
  $conn = connectDB();
  $loginSQL = "SELECT UserID FROM User WHERE UserName ='$userName'
          AND UserPW = '$pw'";
  $data = mysqli_query($conn, $loginSQL) or die (mysqli_error($conn));
  if (mysqli_num_rows($data) == 1) {
      $getIDSQL = "SELECT UserID FROM User WHERE UserName = '".$userName."';";
      $result = $conn->query($getIDSQL);
      $row = $result->fetch_assoc();
      $userID= $row["UserID"];
      echo $userID;
  } else {
      echo "False";
  }
}

//This is the function used to create new task.
function newTask($StartTime, $EndTime, $StartPointX, $StartPointY, $TerminalPointX, $TerminalPointY, $LastPointX, $LastPointY, $LastUpdateTime, $UserID){
  $conn = connectDB();
  $newTaskSQL = "INSERT INTO Task(StartTime, EndTime,StartPointX, StartPointY, TerminalPointX, TerminalPointY, LastPointX, LastPointY, LastUpdateTime, UserID) VALUES('".$StartTime."','".$EndTime."','".$StartPointX."','".$StartPointY."','".$TerminalPointX."','".$TerminalPointY."','".$LastPointX."','".$LastPointY."','".$LastUpdateTime."','".$UserID."');";
  $conn->query($newTaskSQL);
  $conn->close();
  echo $newTaskSQL;
}

//This is the function used to update the contacts information.
function cancelTask($UserID){
  $conn = connectDB();
  $cancelSQL = "UPDATE Task SET Canceled = 'Y' WHERE UserID = '".$UserID."'";
  $conn->query($cancelSQL);
  echo $cancelSQL;
  $conn->close();
}

//This is the function used to update the contacts information.
function updateContacts($UserID,$C1Name,$C1Email,$C2Name,$C2Email){
  $conn = connectDB();
  $updateSQL = "UPDATE User SET C1Name = '".$C1Name."', C1Email = '".$C1Email."', C2Name = '".$C2Name."', C2Email = '".$C2Email."' WHERE UserID = '".$UserID."'";
  $conn->query($updateSQL);
  $conn->close();
}

//This function returen user's contacts information.
function getContacts($UserID){
  $conn = connectDB();
  $getContactsSQL = "Select C1Name, C1Email, C2Name, C2Email from User WHERE UserID = '".$UserID."';";
  $result = $conn->query($getContactsSQL);
  $row = $result->fetch_assoc();
  $c1Name=$row["C1Name"];
  $c1Email=$row["C1Email"];
  $c2Name =$row["C2Name"];
  $c2Email=$row["C2Email"];
  $feedback = $c1Name.",".$c1Email.",".$c2Name.",".$c2Email;
  echo $feedback;
  $conn->close();
}

//This function is used to update user's location until the task is finished or canceled.
function  updateLocation($UserID, $LastPointX, $LastPointY,$LastUpdateTime){
  $conn = connectDB();
  $updateLocationSQL = "UPDATE Task SET Task.LastPointX =".$LastPointX.", Task.LastPointY =".$LastPointY.", Task.LastUpdateTime = ".$LastUpdateTime." WHERE Task.UserID = ".$UserID." AND Task.Canceled = 'N';";
  $conn->query($updateLocationSQL);
  $conn->close();
}
?>
