<?php //FormatResults.php 
// Functions to format the data returned from database

function formatAddress($row)
{
    //pull together address details into one formatted string
    
    
    //$words = preg_split('/[\s,]+/',$var);
    
    //$num = count($words);
    //for ($i = 0 ; $i < $num ; ++$i)
    //{
        //all alphabetic characters stored in uppercase
        //$words[$i] = strtoupper($words[$i]);
    //}
    //$var = implode(" +",$words);
    //$var = "+" . $var;
    $addressString = '';
    //SAON
    $strTemp = $row[SAON];
    $strTemp = $strTemp.trim();
    if (!empty($strTemp))
    {
        $strTemp = formatString ($strTemp);
        $addressString = $addressString . $strTemp . ",";
    }
    //PAON
    $strTemp = $row[PAON];
    $strTemp = $strTemp.trim();
    if (!empty($strTemp))
    {
        $strTemp = formatString ($strTemp);
        $addressString = $addressString . $strTemp . ",";
    }
    //Street
    $strTemp = $row[Street];
    $strTemp = $strTemp.trim();
    if (!empty($strTemp))
    {
        $strTemp = formatString ($strTemp);
        $addressString = $addressString . $strTemp . ",";
    }
    //Locality
    $strTemp = $row[Locality];
    $strTemp = $strTemp.trim();
    if (!empty($strTemp))
    {
        $strTemp = formatString ($strTemp);
        $addressString = $addressString . $strTemp . ",";
    }
    //District
    $strTemp = $row[District];
    $strTemp = $strTemp.trim();
    if (!empty($strTemp))
    {
        $strTemp = formatString ($strTemp);
        $addressString = $addressString . $strTemp . ",";
    }
    //County
    $strTemp = $row[County];
    $strTemp = $strTemp.trim();
    if (!empty($strTemp))
    {
        $strTemp = formatString ($strTemp);
        $addressString = $addressString . $strTemp . ",";
    }
    $addressString = $addressString . $row[Postcode1] . " " . $row[Postcode2];
    return $addressString; 
}

function formatString($var)
{
    $words = preg_split('/[\s,]+/',$var);
    $num = count($words);
    for ($i = 0 ; $i < $num ; ++$i)
    {
        //all alphabetic characters lowercase with first character uppercase
        $words[$i] = ucfirst(strtolower($words[$i]));
    }
    $var = implode(" ",$words);
    return $var;
}

function formatPropertyType($var)
{
    switch ($var)
    {
        case "F":
            $var = "Flat";
            break;
        case "S":
            $var = "Semi";
            break;
        case "D":
            $var = "Detach";
            break;
        case "T":
            $var = "Terrace";
            break;
        default:
    }
    return $var;
}


?>
