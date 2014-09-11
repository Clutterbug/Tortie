<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Tortie Locations</title>

    <!--<script type="text/javascript" src="wpscripts/jspngfix.js"></script>-->

    <link rel="stylesheet" href="wpscripts/wpstyles.css" type="text/css"><script type="text/javascript">var blankSrc = "wpscripts/blank.gif";</script>

    <script src="http://maps.googleapis.com/maps/api/js?sensor=false" type="text/javascript"></script>
    <script type="text/JavaScript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script> 
    <script type="text/javascript" src = "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
    <script type="text/javascript" src="http://ajax.microsoft.com/ajax/jQuery.Validate/1.6/jQuery.Validate.js"></script>
    <!--<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDZJWJBInASA3Caxwa3tI8uR4dJRHX4J10&sensor=false"></script>-->
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.0/themes/smoothness/jquery-ui.css" type="text/css" media="all" />

    <style>
    .gBubble
    {
        color:black;
        font-family:Tahoma, Geneva, sans-serif;
        font-size:12px;    
    }
    </style>
  
    <!-- include local js functions -->
    <script type="text/javascript" src ="tortielocs.js"></script>
</head>

<!--
<body text="#000000" style="background:#a0a0a0 url('wpimages/wp1ae331bc_06.png') repeat scroll top center; height:840px;">
-->
    <body text="#000000" style="background:#a0a0a0 url('wpimages/wp1ae331bc_06.png') ">
        
<!-- the whole body of web site is stored in a div -->

<div style="background-color:transparent;margin-left:auto;margin-right:auto;position:relative;width:1000px;height:840px;">
     
    
    <!-- Page Header  -->
    <img src="wpimages/wp5f8bef02_06.png" border="0" width="958" height="142" id="txt_116" title="" alt="Tortie Analytics&#10;" onload="OnLoadPngFix()" usemap="#map0" style="position:absolute;left:20px;top:10px;">
    <a href=""><img src="wpimages/wp0fd99c1f_06.png" border="0" width="180" height="23" id="txt_117" title="" alt="Informed by Data&#10;" onload="OnLoadPngFix()" style="position:absolute;left:820px;top:55px;"></a>
    
    <!-- menu bar -->
    <div id="nav_405" style="position:absolute;left:324px;top:92px;width:520px;height:108px;">
        <a href="" id="nav_405_B1" class="Button1" style="display:block;position:absolute;left:10px;top:30px;width:96px;height:33px;"><span>Location</span></a>
        <a href="" id="nav_405_B2" class="Button1" style="display:block;position:absolute;left:108px;top:30px;width:96px;height:33px;"><span>Commute</span></a>
        <a href="" id="nav_405_B3" class="Button1" style="display:block;position:absolute;left:206px;top:30px;width:96px;height:33px;"><span>Property&nbsp;Prices</span></a>
        <a href="" id="nav_405_B4" class="Button1" style="display:block;position:absolute;left:304px;top:30px;width:96px;height:33px;"><span>Schools</span></a>
        <a href="" id="nav_405_B5" class="Button1" style="display:block;position:absolute;left:402px;top:30px;width:96px;height:33px;"><span>Demographics</span></a>
    </div>
    <img src="wpimages/wp9481074d_06.png" border="0" width="273" height="47" id="txt_119" title="" alt="Where’s home?&#10;" onload="OnLoadPngFix()" style="position:absolute;left:417px;top:74px;">
    <img src="wpimages/wpef79f214_06.png" border="0" width="958" height="636" id="pcrv_275" alt="" onload="OnLoadPngFix()" style="position:absolute;left:20px;top:151px;">
    <!-- end of page header -->
    
    
    <!-- search criteria div -->
    <div id="search">
        <form id="form_28" onsubmit="return validate_form_28(this)" action="" target="_self" enctype="application/x-www-form-urlencoded" style="margin:0;position:absolute;left:250px;top:160px;width:541px;height:51px;">
        <div id="txt_126" style="position:absolute;left:8px;top:14px;width:185px;height:25px;overflow:hidden;">
            <p class="Wp-Normal-P"><label for="edit_19"><span class="Normal-C">Search for a Location</span></label></p>
        </div>
        <input type="text" id="userloc" name="UserLocation" value="Enter place, area or partial postcode (eg KT1)" onfocus="if (this.value=='Enter place, area or partial postcode (eg KT1)') this.value='';" style="position:absolute; left:192px; top:12px; width:283px;">
        <div style="position:absolute;left:475px;top:2px;width:66px;height:43px;"><button type="submit" id="btn_4" class="Button2" style="width:66px;height:43px;"></button></div>
        </form>
    </div>
    <!-- end of search criteria div -->
    
    <!-- results div -->
    <div id="results" style="position:absolute;left:25px;top:205px;width:935px;height:570px;background: transparent no-repeat top left;overflow-y:scroll">
        <table id="HeadlineStats" class='hs' cellspacing="10"> 
            <tr>
                <th colspan="2" rowspan="2">Location<br><button class="LocCriteriaButton">Set Criteria</button></th>
                <th rowspan="2">Property Prices<br><button class="PropCriteriaButton">Set Criteria</button></th>
                <th rowspan="2">Commute<br><button class="ComCriteriaButton">Set Criteria</button></th>
                <th colspan="2">Closest Schools&nbsp&nbsp<button class="CriteriaButton">Set Criteria</button></th>
            </tr>
            <tr class="secondrow">
                <th>Primary</th>
                <th>Secondary</th>
            </tr>        
        </table>
    </div>
    <!-- end of results div -->
    
    <!-- div for map -->    
    <div id="map_container" title="Location Map">    
        <div id="map_canvas" style="width:100%;height:100%;"></div>
    </div>
    
    <!--
    <div id='testdiv' style="position:absolute;left:5px;top:400px;width:900px;height:1500px;background: transparent no-repeat top left;">
        <p>This is our test div</p>
    </div>
    -->
    <div style="font-size : 12px;position:absolute;left:300px;top:750px;width:940px;height:30px;background: transparent no-repeat top left;">
    Contains Ordnance Survey data © Crown copyright and database right 2013<br>
    Contains National Statistics data © Crown copyright and database right 2013 
    </div>
    
    <!-- section demarcation lines -->
    <img src="wpimages/wp408aa91d_06.png" border="0" width="958" height="1" id="crv_22" alt="" onload="OnLoadPngFix()" style="position:absolute;left:20px;top:150px;">
    <img src="wpimages/wp408aa91d_06.png" border="0" width="958" height="1" id="pcrv_276" alt="" onload="OnLoadPngFix()" style="position:absolute;left:20px;top:782px;">
   
    
    <script type="text/javascript" src="wpscripts/jsValidation.js"></script>

    <!-- footer -->
        <!-- Footer background strip -->
        <img src="wpimages/wp1f798008_06.png" border="0" width="958" height="45" id="qs_18" alt="" onload="OnLoadPngFix()" style="position:absolute;left:20px;top:785px;">

    <div id="txt_19" style="position:absolute;left:30px;top:790px;width:940px;height:20px;overflow:hidden;">
        <p class="Wp-Footer-P"><span class="Footer-C">Copyright © tortie.co.uk </span></p>
    </div>
    <!-- end of footer -->
<!-- close main body div -->
</div>
</body>
</html>