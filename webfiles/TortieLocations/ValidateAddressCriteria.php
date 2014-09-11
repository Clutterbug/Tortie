<?php //ValidateAddressCriteria.php 
// Functions to process the input data for query

function formatSearchString($var)
{
    
    $var = sanitizeString($var);
    $var = sanitizeMySQL($var);
    
    //separate out search words by any number of commas or
    //space characters which include  " ",\r,\t,\n and \f
    $words = preg_split('/[\s,]+/',$var);
    
    $num = count($words);
    for ($i = 0 ; $i < $num ; ++$i)
    {
        //all alphabetic characters stored in uppercase
        $words[$i] = strtoupper($words[$i]);
    }
    $var = implode(" +",$words);
    $var = "+" . $var;
    
    return $var; 
}

function sanitizeString($var)
{
    $var = stripslashes($var);
    $var = htmlentities($var);
    $var = strip_tags($var);
    return $var;
}

function sanitizeMySQL($var)
{
    $var = mysql_real_escape_string($var);
    $var = sanitizeString($var);
    return $var;
}
?>
