<?php
//Variables to connect to database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "wave_lab_database";

$action = $_POST["action"];

//Connect to the database
$conn = new mysqli($servername, $username, $password, $dbname);

//Check connection to database
if($conn->connect_error){
    die("Connection Failed: " . $conn->connect_error);
    return;
}


if("GET_CUR_DEPTH_DWB" == $action){
    $new_depth = array();
    $sql = "SELECT * FROM `depth_data` WHERE Depth_Flume_Name = 0 ORDER BY Ddate DESC LIMIT 1";
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

else if("GET_CUR_DEPTH_LWF" == $action){
    $new_depth = array();
    $sql = "SELECT * FROM `depth_data` WHERE Depth_Flume_Name = 1 ORDER BY Ddate DESC LIMIT 1";
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

else if("GET_ALL_DEPTH_DWB" == $action){
    $new_depth = array();
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

else if("GET_ALL_DEPTH_LWF" == $action){
    $new_depth = array();
    $sql = "SELECT * FROM `depth_data` WHERE Depth_Flume_Name = 1 ORDER BY Ddate DESC";
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
else if("GET_T_DEPTH_DWB" == $action){
    $new_depth = array();
    $sql = "SELECT * FROM `target_depth` WHERE Target_Flume_Name = 0 AND isComplete = 0 ORDER BY Tdate DESC LIMIT 1";
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

else if("GET_T_DEPTH_LWF" == $action){
    $new_depth = array();
    $sql = "SELECT * FROM `target_depth` WHERE Target_Flume_Name = 1 AND isComplete = 0 ORDER BY Tdate DESC LIMIT 1";
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

else if("GET_PREV_T_DWB" == $action){
    $new_depth = array();
    $sql = "SELECT * FROM `target_depth` WHERE Target_Flume_Name = 0 AND isComplete = 1 ORDER BY Tdate DESC LIMIT 1";
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

else if("GET_PREV_T_LWF" == $action){
    $new_depth = array();
    $sql = "SELECT * FROM `target_depth` WHERE Target_Flume_Name = 1 AND isComplete = 1 ORDER BY Tdate DESC LIMIT 1";
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

else if("ADD_T_DEPTH" == $action){
    $Tdepth = $_POST["Tdepth"];
    $fName = $_POST["fName"];
    $Tdate = $_POST["Tdate"];
    $uName = $_POST["uName"];
    $isComplete = $_POST["isComplete"];
    $sql = "INSERT INTO `target_depth` (`Tdepth`, `Target_Flume_Name`, `Tdate`, `Username`, `isComplete`) VALUES ('$Tdepth', '$fName', '$Tdate', '$uName', '$isComplete')";
    $result = $conn->query($sql);
    echo "success";
    $conn->close();
    return;
}

else if("LOGIN_USER" == $action){
    $uName = $_POST["username"];
    $pWord = $_POST["password"];
    $sql = "SELECT * FROM `user` WHERE Username = '$uName' AND Password = '$pWord' LIMIT 1";
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