<?php

ini_set('display_errors', 'on');
include('connect.php');
include('ESMSWS.php');

$da = date('Y-m-d H:i:s');
$randomdata = rand(10000,99999);

$qrt_DB_HRIS ="SELECT * FROM FLUTTER_APP_USERS Where MOBILE_NO ='".$_POST['contact']."' limit 1";


$result_DB_HRIS = mysqli_query($DB_HRIS_conn, $qrt_DB_HRIS);
if (mysqli_num_rows($result_DB_HRIS) > 0) {
    $i = 1;
     while($row1_DB_HRIS = mysqli_fetch_assoc($result_DB_HRIS)) {
       
$to = $_POST['contact'];
$subject = "OTP:$randomdata";
$etxt =  "Dear User, Please Use the following OTP:$randomdata to complete your online request.";
$footer = "IAssist Team";
$client_id = "";
//$utxt = $_GET['utxt'];


$date = date( 'Y-m-d H:i:s' );


if (ctype_digit($to)) {
    
    $session = createSession('', 'esmsusr_OsnbfGmX', 'mhirmBJj', '');
    sendMessages($session, 'HAYLEYS SLR', $subject."\n".$etxt. "\n" . $footer, array($to), 1); 
    closeSession($session);
    echo "success" . ":" . $randomdata;
     
  
} 
         
     }
    
    
}else {
    echo "0";
}
    
    ?>






