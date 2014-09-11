<?php
$term = $_REQUEST["term"];
$term = utf8_decode ($term);
  
$path = $_SERVER['DOCUMENT_ROOT'];

require_once 'login.php';
// Validate user input 
require_once 'ValidateUserInput.php';
$term = sanitizeString($term);


$result = null;
$results = null;

$pdo = new PDO("mysql:host=$db_hostname;dbname=tortie_co_uk_db", $db_username, $db_password);
$sql = "CALL getAjaxLocationListProc (:term)";   
   
$query = $pdo->prepare($sql);
// bind parameters to prepared statement
$query->bindParam(':term', $term);
// Query execution
$query->execute();

while ($row = $query->fetch(PDO::FETCH_ASSOC)){
    echo ("<li>" . utf8_encode ($row["Def_Nam"]) . ", " . utf8_encode ($row["Co_Name"]) . "</li>");
}
$pdo = null; 

?>
