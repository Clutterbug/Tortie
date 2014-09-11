<?php
setlocale(LC_MONETARY,'en_GB.UTF-8');

$pcom = $_REQUEST["pcom"];
$prc = $_REQUEST["prc"];
$pcofe = $_REQUEST["pcofe"];
$inf = $_REQUEST["inf"];
$jun = $_REQUEST["jun"];
$pind = $_REQUEST["pind"];
$pnum = $_REQUEST["pnum"];
$scom = $_REQUEST["scom"];
$src = $_REQUEST["src"];
$scofe = $_REQUEST["scofe"];
$soth = $_REQUEST["soth"];
$coed = $_REQUEST["coed"];
$girls = $_REQUEST["girls"];
$boys = $_REQUEST["boys"];
$sel = $_REQUEST["sel"];
$sind = $_REQUEST["sind"];
$snum = $_REQUEST["snum"];

$userloc = $_REQUEST["userloc"];
$userloc = utf8_decode ($userloc);

$locParts = preg_split('/\,/',$userloc);

$locTown = "";
$locCounty = "";

//The town sometimes has a comma in it, but only when followed by the word "The".  
//We need to deal with this as we split the user data field by the comma.
if (trim($locParts[1]) == 'The') {
    $locTown = trim($locParts[0]) . ", " . trim($locParts[1]);
    $locCounty = trim($locParts[2]);
} else {
    $locTown = trim($locParts[0]);
    $locCounty = trim($locParts[1]);
}

//if nothing is selected then default to retrieve any state school
$pminor = "^Maintained|^Academy";
$pnftype = "^";
$prel = "^";
$sminor = "^Maintained|^Academy";
$snftype = "^";
$srel = "^";

//select community schools
if ($pcom == 'checked'){ 
    $pnftype = '^Community|^Academy|^Free';
    $prel = '^Does';
}
if ($scom == 'checked'){ 
    $snftype = '^Community|^Academy|^Free';
    $srel = '^Does';
}

//select Roman Catholic schools
if ($prc == 'checked') {
    if ($prel != "^") {
        $prel = $prel . '|^Roman';
    } else {
        $prel = '^Roman';
    }
}   
if ($src == 'checked') {
    if ($srel != "^") {
        $srel = $prel . '|^Roman';
    } else {
        $srel = '^Roman';
    }
}

//select C of E schools
if ($pcofe == 'checked') {
    if ($prel != "^") {
        $prel = $prel . '|^Church';
    } else {
        $prel = '^Church';
    }
} 
if ($scofe == 'checked') {
    if ($srel != "^") {
        $srel = $srel . '|^Church';
    } else {
        $srel = '^Church';
    }
} 

//select other VA schools
if ($poth == 'checked') {
    if ($prel != "^") {
        $prel = $prel . '|^';
    } else {
        $prel = '^';
    }
}   
if ($soth == 'checked') {
    if ($srel != "^") {
        $srel = $srel . '|^';
    } else {
        $srel = '^';
    }
}   

//set nftype value if we are selecting any type of VA school
if ($prc == 'checked' | $pcofe == 'checked' | $poth == 'checked') {
    if ($pnftype != "^") {
        $pnftype = $pnftype . '|^Voluntary';
    } else {
        $pnftype = '^Voluntary';
    }
}
if ($src == 'checked' | $scofe == 'checked' | $soth == 'checked') {
    if ($snftype != "^") {
        $snftype = $snftype . '|^Voluntary';
    } else {
        $snftype = '^Voluntary';
    }
}

$path = $_SERVER['DOCUMENT_ROOT'];

require_once 'login.php';
// Validate user input 
require_once 'ValidateUserInput.php';
$locTown = sanitizeString($locTown);


$result = null;
$results = null;
  
$pdo = new PDO("mysql:host=$db_hostname;dbname=tortie_co_uk_db", $db_username, $db_password);
$sql = "CALL getLocationDataProc (:locname,:loccounty,:pminor,:pnftype,:prel,:pnum,:sminor,:snftype,:srel,:snum)";   
   
$query = $pdo->prepare($sql);

// bind parameters to prepared statement
$query->bindParam(':locname', $locTown);
$query->bindParam(':loccounty', $locCounty);
$query->bindParam(':pminor', $pminor);
$query->bindParam(':pnftype', $pnftype);
$query->bindParam(':prel', $prel);
$query->bindParam(':pnum', $pnum);
$query->bindParam(':sminor', $sminor);
$query->bindParam(':snftype', $snftype);
$query->bindParam(':srel', $srel);
$query->bindParam(':snum', $snum);

$query->execute();
      
while ($row = $query->fetch(PDO::FETCH_ASSOC)){
    
    //split out the primary schools
    $pschname = preg_split('/\;/',$row["ClosestPSchool"]);
    $pschdist = preg_split('/\;/',$row["PDist"]);
    $pschofsted = preg_split('/\;/',$row["POfsted"]);
    //split out the secondary schools
    $sschname = preg_split('/\;/',$row["ClosestSSchool"]);
    $sschdist = preg_split('/\;/',$row["SDist"]);
    $sschofsted = preg_split('/\;/',$row["SOfsted"]);
        
    $pschs = array();
    for ($j=0;$j<$pnum; $j++)
    {
        $pschs[$j] = array ('pname' => utf8_encode ($pschname[$j]),
                            'pdist' => utf8_encode ($pschdist[$j]),
                            'pofsted' => utf8_encode ($pschofsted[$j])
                           );
    }
    
        
    $sschs = array();
    for ($j=0;$j<$snum; $j++)
    {
        $sschs[$j] = array ('sname' => utf8_encode ($sschname[$j]),
                            'sdist' => utf8_encode ($sschdist[$j]),
                            'sofsted' => utf8_encode ($sschofsted[$j])
                           );
    }
    
   
    
        
    $locData = array(
        'latitude' => utf8_encode ($row["latitude"]),
        'longitude' => utf8_encode ($row["longitude"]),
        'town' => utf8_encode ($row["Town_ukp"]),
        'county' => utf8_encode ($row["Town_lr"]),
        'ward' => utf8_encode ($row["ClosestWard"]),
        'avprice' => money_format('%.0n',$row["AvPrice"]),
        'terminus' => utf8_encode ($row["Terminus"]),
        'station' => utf8_encode ($row["Station"]),
        'durationterm' => utf8_encode ($row["DurationTerm"]),
        'pnum' => utf8_encode ($pnum),
        'snum' => utf8_encode ($snum),
        'pschool' => $pschs,
        'sschool' => $sschs        
    );    
  
    echo json_encode($locData);
    
}
$pdo = null;  
  
?>
