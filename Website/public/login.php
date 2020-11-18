<?php
	require_once 'conn.php';
 
	if(ISSET($_POST['login'])){
		$Username = $_POST['Username'];
		$Password = $_POST['Password'];
 
		$query=$conn->query("SELECT COUNT(*) as count FROM `user` WHERE `username`='$username' AND `password`='$password'");
		$row=$query->fetchArray();
		$count=$row['count'];
 
		if($count > 0){
			echo "<div class='alert alert-success'>Login successful</div>";
		}else{
			echo "<div class='alert alert-danger'>Invalid username or password</div>";
		}
	}
?>