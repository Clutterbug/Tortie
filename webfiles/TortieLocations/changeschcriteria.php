<?php
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
$locs = $_REQUEST["locs"];

//locs is an array of all the locations in the displayed table
//first find the array size
$rows = count($locs);
//separate the town from the county for each location
for ($i=0;$i<$rows; $i++)
{
    $locParts[$i] = preg_split('/\<br>/',$locs[$i]);
}

$pnum = utf8_decode ($pnum);
$snum = utf8_decode ($snum);

$path = $_SERVER['DOCUMENT_ROOT'];

require_once 'login.php';
// Validate user input 
require_once 'ValidateUserInput.php';
$pnum = sanitizeString($pnum);
$snum = sanitizeString($snum);

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
        $pnftype = '^Voluntary|^Academy';
    }
}
if ($src == 'checked' | $scofe == 'checked' | $soth == 'checked') {
    if ($snftype != "^") {
        $snftype = $snftype . '|^Voluntary';
    } else {
        $snftype = '^Voluntary|^Academy';
    }
}

$result = null;

$schData = array();

for ($i=0;$i<$rows; $i=$i+1)
{ 
    //we have to create a new connection each time.  Can't fathom out why...
    $pdo = new PDO("mysql:host=$db_hostname;dbname=tortie_co_uk_db", $db_username, $db_password);
    $sql = "CALL getSchoolsDataProc(:locname,:loccounty,:pminor,:pnftype,:prel,:pnum,:sminor,:snftype,:srel,:snum)";   
   
    $query = $pdo->prepare($sql);
   
    // bind parameters to prepared statement
    $query->bindParam(':locname', $locParts[$i][0]);
    $query->bindParam(':loccounty', $locParts[$i][1]);
    $query->bindParam(':pminor', $pminor);
    $query->bindParam(':pnftype', $pnftype);
    $query->bindParam(':prel', $prel);
    $query->bindParam(':pnum', $pnum);
    $query->bindParam(':sminor', $sminor);
    $query->bindParam(':snftype', $snftype);
    $query->bindParam(':srel', $srel);
    $query->bindParam(':snum', $snum);
    
    $query->execute();
    
    $pschs = "";
    $sschs = "";
    //two rows should be returned, one for secondary schools, one for primary schools
    while ($row = $query->fetch(PDO::FETCH_ASSOC)){
                
        //split out the primary schools
        if ($row["pors"]=='P'){ 
            $pschname = preg_split('/\;/',$row["schname"]);
            $pschdist = preg_split('/\;/',$row["distance"]);
            $pschofsted = preg_split('/\;/',$row["ofsted"]);
            $pschs = array();
            for ($j=0;$j<$pnum; $j++)
            {
                $pschs[$j] = array ('pname' => utf8_encode ($pschname[$j]),
                                    'pdist' => utf8_encode ($pschdist[$j]),
                                    'pofsted' => utf8_encode ($pschofsted[$j])
                                );
            }
            
        } else {
            //split out the secondary schools
            $sschname = preg_split('/\;/',$row["schname"]);
            $sschdist = preg_split('/\;/',$row["distance"]);
            $sschofsted = preg_split('/\;/',$row["ofsted"]);
            $sschs = array();
            for ($j=0;$j<$snum; $j++)
            {
                $sschs[$j] = array ('sname' => utf8_encode ($sschname[$j]),
                                    'sdist' => utf8_encode ($sschdist[$j]),
                                    'sofsted' => utf8_encode ($sschofsted[$j])
                                );
            }
        }
    
    }
    
    $schData[$i] = array(
            'town' => $locParts[$i][0],
            'county' => $locParts[$i][1],
            'pnum' => utf8_encode ($pnum),
            'snum' => utf8_encode ($snum),
            'primschools'=> $pschs,
            'secschools' => $sschs 
    );       
    
    $pdo = null;  
}

  
$test = array('rows' => $loop);

echo json_encode($schData);
?>