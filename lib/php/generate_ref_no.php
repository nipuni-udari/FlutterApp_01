<?php
header('Content-Type: text/plain');
$dat = date("YmdHis");
$refNo = "REF" . $dat;
echo $refNo;
?>
