<?php
//Variables to connect to database
$servername = "localhost";
$username = "root";
$password = '';
$dbname = 'wave_lab_database';

$action = $_POST["action"];

//Connect to the database
$conn = new mysqli($servername, $username, $password, $dbname);

//Check connection to database
if($conn->connect_error){
    die("Connection Failed: " . $conn->connect_error);
    return;
}

print "in!";

if("GET_DEPTH_DWB" == $action){
    $new_depth;
    $sql = "SELECT * FROM `depth_data` WHERE Depth_Flume_Name = 0 ORDER BY Ddate DESC";
    $result = $conn->query($sql);
    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            $db_data[] = $row;
        }

        echo json_encode($db_data);
    }
    else{
        echo "error";
    }
    $conn->close();
    return;
}

else if("GET_DEPTH_LWF" == $action){
    $new_depth = '';
    $sql = "SELECT Depth FROM `depth_data` WHERE Depth_Flume_Name = 1 ORDER BY Ddate DESC LIMIT 1";
    $result = $conn->query($sql);
    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            $db_data[] = $row;
        }
        echo json_encode($db_data);
    }
    else{
        echo "error";
    }
    $conn->close();
    return;
}
?>