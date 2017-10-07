<?php
/**
 * Created by PhpStorm.
 * User: wei
 * Date: 9/18/17
 * Time: 11:15 AM
 */

error_reporting(-1);
ini_set('display_errors', 'On');
set_error_handler("var_dump");
require_once('info.php');
taskManager();

// This is the controler of the server side function.
// Since server should keep running. This function is an infinite loop.
// The server would operate the detect function each 60 seconds.
function taskManager(){
    $condition = "I love PHP";
    while ($condition){
      operateTask();
      sleep(20);

    }
}
// Set up an short connection to the database.
function connectDB()
{
    $dbc = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
    return $dbc;
}
// The function check all the tasks in the database and detect if any task if
// experid but did cancel by user.
// The system would automatically send notification to the user's contacts.
function operateTask(){
    $currentTime=time();
    $conn = connectDB();
    $searchSQL = "SELECT * FROM Task INNER JOIN User WHERE User.UserID=Task.UserID AND Task.Canceled = 'N' AND Task.endTime <  ".$currentTime.";";
    $taskList = $conn->query($searchSQL);
while ($row = $taskList->fetch_assoc()) {
    $taskID= $row["TaskID"];
    $name = $row["RealName"];
    $c1Name=$row["C1Name"];
    $c1Email=$row["C1Email"];
    $c2Name =$row["C2Name"];
    $c2Email=$row["C2Email"];
    $startTime = $row["StartTime"];
    $endTime = $row["EndTime"];
    $startPointX = $row["StartPointX"];
    $startPointY = $row["StartPointY"];
    $terminalPointX = $row["TerminalPointX"];
    $terminalPointY = $row["TerminalPointY"];
    $lastPointX = $row["LastPointX"];
    $lastPointY = $row["LastPointY"];
    $lastUpdateTime = $row["LastUpdateTime"];
    $cancelTaskSQL = "UPDATE Task SET Task.Canceled = 'Y' WHERE Task.TaskID=".$taskID.";";
    $conn->query($cancelTaskSQL);
    sendEmail($c1Email,$c1Name,$c2Email,$c2Name,$name,$startTime,$endTime,$startPointX,$startPointY,$terminalPointX,$terminalPointY, $lastPointX, $lastPointY,$lastUpdateTime);
}
$conn->close();

}

// This function is used to send email.
function sendEmail($c1Email,$c1Name,$c2Email,$c2Name,$name,$startTime,$endTime,$startPointX,$startPointY,$terminalPointX,$terminalPointY, $lastPointX, $lastPointY,$lastUpdateTime){
  $url = "Location:http://115.146.92.149/include/listener.php?c1email=".$c1Email."&c1name=".$c1Name."&c2email=".$c2Email."&c2name=".$c2Name."&name=".$name."&startTime=".$startTime."&endTime=".$endTime."&startPointX=".$startPointX."&startPointY=".$startPointY."&terminalPointX=".$terminalPointX."&terminalPointY=".$terminalPointY."&lastPointX=".$lastPointX."&lastPointY=".$lastPointY."&lastUpdateTime=".$lastUpdateTime;
echo $url;
  header($url);
}
?>
