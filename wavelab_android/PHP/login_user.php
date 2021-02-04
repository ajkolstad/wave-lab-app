<?php
     $HostName = "localhost";                                               //Define your Server host name here.
     $DatabaseName = "wave_lab_database";                                   //Define your MySQL Database Name here.
     $HostUser = "root";                                                    //Define your Database User Name here.
     $HostPass = "";                                                        //Define your Database Password here.
     $con = mysqli_connect($HostName,$HostUser,$HostPass,$DatabaseName);    // Creating MySQL Connection.
     $json = file_get_contents('php://input');                              // Getting the received JSON into $json variable.
     $obj = json_decode($json,true);                                        // Decoding the received JSON and store into $obj variable.
     $username = $obj['username'];                                          // Getting User email from JSON $obj array and store into $email.
     $password = $obj['password'];                                          // Getting Password from JSON $obj array and store into $password.

     //Applying User Login query with email / password execute SQL Query
     $loginQuery = "select * from user_registration where username = '$username' and password = '$password' ";
     $check = mysqli_fetch_array(mysqli_query($con,$loginQuery));
     //output success message, convert to JSON format and echo to terminal, otherwise error statement to terminal, convert to JSONa nd echo to terminal
     if(isset($check))
     {
         $onLoginSuccess = 'Login Matched';
         $SuccessMSG = json_encode($onLoginSuccess);
         echo $SuccessMSG ;
     }
     else
     {
        $InvalidMSG = 'Invalid Username or Password Please Try Again' ;
        $InvalidMSGJSon = json_encode($InvalidMSG);
        echo $InvalidMSGJSon ;
     }
     mysqli_close($con);
?>