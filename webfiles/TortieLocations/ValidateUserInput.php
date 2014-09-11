<?php //ValidateUserInput.php 
// Functions to process the input data for query

function sanitizeString($var)
{
    $var = stripslashes($var);
    $var = htmlentities($var);
    $var = strip_tags($var);
    return $var;
}

function sanitizeMySQL($var)
{
    $var = mysqli_real_escape_string($var);
    $var = sanitizeString($var);
    return $var;
}
?>
