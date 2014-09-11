//tortie locs javascript functions
    var map;
    var coords = new Object();
    var markersArray = [];
    
$(document).ready(function() {
    

$("input#userloc").autocomplete ({
  source : function (request, callback)
  {
    var data = { term : request.term };
    $.ajax ({
      url : "locationlookup.php",
      data : data,
      complete : function (xhr, result)
      {
        if (result != "success") return;
        var response = xhr.responseText;
        var locations = [];

        $(response).filter ("li").each (function ()
        {
          locations.push ($(this).text ());
        });
        callback (locations);
      }
    });
  }
});
   
$('#HeadlineStats th').hide();

function processSchools(params) {
        var pschHTML;
        var sschHTML;
        var town;
        var county;
        var dispLoc;
        var dispArr;
        var rows = 0;
        var found = 0;
        rows = params.length;
        
        for (i=0;i<rows;i++) {
            
            town = params[i].town;
            county = params[i].county;  
            //sschHTML = data[i].secschools;  
            
            $('#HeadlineStats').find('.RowClass').each(function(){
                $(this).find('.LocClass').each(function(){
                    dispLoc = $(this).html();
                    dispArr = dispLoc.split('<br>');
                
                    if ((dispArr[0]==town) & (dispArr[1]==county)) {
                        found = 1;
                    } else {
                        found = 0;
                    };
                    
                });
                    
                if (found) {
                    $(this).find('.PrimSchClass').each(function(){
                        pschHTML = "<table class='schtab'>"; 
                        
                        for (var j=0; j<params[i].pnum; j++){
                            pschHTML = pschHTML + "<tr>";
                            pschHTML = pschHTML + "<td class='schtd'>" + params[i].primschools[j].pname;
                            pschHTML = pschHTML + "</td><td class='schtd'>" + params[i].primschools[j].pdist + " km</td>";
                            switch (params[i].primschools[j].pofsted){
                                case "1":
                                    pschHTML = pschHTML + "<td class='sch1'>" + params[i].primschools[j].pofsted + "</td>";
                                    break;
                                case "2":
                                    pschHTML = pschHTML + "<td class='sch2'>" + params[i].primschools[j].pofsted + "</td>";
                                    break;
                                case "3":
                                    pschHTML = pschHTML + "<td class='sch3'>" + params[i].primschools[j].pofsted + "</td>";
                                    break;
                                case "4":
                                    pschHTML = pschHTML + "<td class='sch4'>" + params[i].primschools[j].pofsted + "</td>";
                                    break;
                                default:
                                    pschHTML = pschHTML + "<td class='schunc'></td>";
                                    break;
                        }
                            pschHTML = pschHTML + "</tr>";
                        }
                        
                        pschHTML = pschHTML + "</table>";
                                      
                        $(this).html(pschHTML);   
                    });    
                    
                    
                    $(this).find('.SecSchClass').each(function(){
                        sschHTML = "<table class='schtab'>"; 
                        
                        for (var j=0; j<params[i].snum; j++){
                            sschHTML = sschHTML + "<tr>";
                            sschHTML = sschHTML + "<td class='schtd'>" + params[i].secschools[j].sname;
                            sschHTML = sschHTML + "</td><td class='schtd'>" + params[i].secschools[j].sdist + " km</td>";
                            switch (params[i].secschools[j].sofsted){
                                case "1":
                                    sschHTML = sschHTML + "<td class='sch1'>" + params[i].secschools[j].sofsted + "</td>";
                                    break;
                                case "2":
                                    sschHTML = sschHTML + "<td class='sch2'>" + params[i].secschools[j].sofsted + "</td>";
                                    break;
                                case "3":
                                    sschHTML = sschHTML + "<td class='sch3'>" + params[i].secschools[j].sofsted + "</td>";
                                    break;
                                case "4":
                                    sschHTML = sschHTML + "<td class='sch4'>" + params[i].secschools[j].sofsted + "</td>";
                                    break;
                                default:
                                    sschHTML = sschHTML + "<td class='schunc'></td>";
                                    break;
                        }
                            sschHTML = sschHTML + "</tr>";
                        }
                        
                        sschHTML = sschHTML + "</table>";
                        
                        $(this).html(sschHTML);   
                    });
                }        
        });
        
   }
}

$("div#SchoolCriteria").dialog ({
        autoOpen : false,
        width: 350,
        height: 450,
        modal: true,
        buttons : [{
                text: "OK",
                "class" : "OKButton",
                click : function() { 
                        $("div#SchoolCriteria").dialog ("close");
                    }
                }]
             
});

// set up the default values
var pcom = "checked";
var prc = "checked";
var pcofe = "checked";
var poth = "checked";
var inf = "checked";
var jun = "checked";
var pind = "";
var pnum = 3;
var scom = "checked";
var src = "checked";
var scofe = "checked";
var soth = "checked";
var coed = "checked";
var girls = "checked";
var boys = "checked";
var sel = "checked";
var sind = "";
var snum = 3;


//Bring up the Schools criteria modal and allow user to set the criteria
$('.CriteriaButton').click(function() {

         var NewDialog = $('<div id="SchoolCriteria" title="Set Schools Criteria">\
                            <form>\
                                <p>Primary Schools</p>\
                                <fieldset>\
                                    <label>Community</label><input type="checkbox" name="pCom" id="pCom" ' + pcom +'/>\
                                    <br>\
                                    VA/VC:&nbsp&nbsp<label class="smalltxt">RC</label><input type="checkbox" name="prc" id="prc" ' + prc +'>\
                                    <label class="smalltxt">CofE</label><input type="checkbox" name="pcofe" id="pcofe" ' + pcofe +'>\
                                    <label class="smalltxt">Other VA</label><input type="checkbox" name="poth" id="poth" ' + poth +'>\
                                    <br>\
                                    <label>Infant</label><input type="checkbox" name="inf" id="inf" ' + inf +'/>\
                                    <label>Juniors</label><input type="checkbox" name="jun" id="jun" ' + jun +' />\
                                    <br>\
                                    <label>Independent</label><input type="checkbox" name="pind" id="pind" ' + pind +'/>\
                                    <br>\
                                    <label>Number of Schools to Display</label><input type="text" name="pnum" id="pnum" maxlength="1" size="1" value="' + pnum + '" />\
                                </fieldset>\
                                <p>Secondary Schools</p>\
                                <fieldset>\
                                    <label>Community</label><input type="checkbox" name="sCom" id="sCom" ' + scom +'/>\
                                    <br>\
                                    VA/VC:&nbsp&nbsp<label class="smalltxt">RC</label><input type="checkbox" name="src" id="src" ' + src +'>\
                                    <label class="smalltxt">CofE</label><input type="checkbox" name="scofe" id="scofe" ' + scofe +'>\
                                    <label class="smalltxt">Other VA</label><input type="checkbox" name="soth" id="soth"  ' + soth +'>\
                                    <br>\
                                    <label>Co-ed</label><input type="checkbox" name="coed" id="coed" ' + coed +'/>\
                                    <label>Girls</label><input type="checkbox" name="girls" id="girls" ' + girls +'/>\
                                    <label>Boys</label><input type="checkbox" name="boys" id="boys" ' + boys +'/>\
                                    <br>\
                                    <label>Selective</label><input type="checkbox" name="sel" id="sel"  ' + sel +'/>\
                                    <br>\
                                    <label>Independent</label><input type="checkbox" name="sind" id="sind" ' + sind +' />\
                                    <br>\
                                    <label>Number of Schools to Display</label><input type="stext" name="snum" id="num" maxlength="1" size="1" value="' + snum + '" />\
                                </fieldset>\
                            </form>\
                        </div> ');
        
        // bring up the schools criteria modal with either default or previously set options displayed
        NewDialog.dialog({
            width: 350,
            height: 450,
            modal: true,
            buttons : [{
                text: "OK",
                "class" : "OKButton",
                click : function() { 
                        
                        $(this).find(':checkbox').each(function(){
                            if (this.name=='pCom')
                                if (this.checked)
                                    pcom = "checked";
                                else
                                    pcom = "";
                            if (this.name=='prc')
                                if (this.checked)
                                    prc = "checked";
                                else
                                    prc = "";
                            if (this.name=='pcofe')
                                if (this.checked)
                                    pcofe = "checked";
                                else
                                    pcofe = "";
                            if (this.name=='poth')
                                if (this.checked)
                                    poth = "checked";
                                else
                                    poth = "";
                            if (this.name=='inf')
                                if (this.checked)
                                    inf = "checked";
                                else
                                    inf = "";
                            if (this.name=='jun')
                                if (this.checked)
                                    jun = "checked";
                                else
                                    jun = "";
                            if (this.name=='pind')
                                if (this.checked)
                                    pind = "checked";
                                else
                                    pind = "";                  
                            if (this.name=='sCom')
                                if (this.checked)
                                    scom = "checked";
                                else
                                    scom = "";
                            if (this.name=='src')
                                if (this.checked)
                                    src = "checked";
                                else
                                    src = "";
                            if (this.name=='scofe')
                                if (this.checked)
                                    scofe = "checked";
                                else
                                    scofe = "";    
                            if (this.name=='soth')
                                if (this.checked)
                                    soth = "checked";
                                else
                                    soth = "";
                            if (this.name=='coed')
                                if (this.checked)
                                    coed = "checked";
                                else
                                    coed = "";
                            if (this.name=='girls')
                                if (this.checked)
                                    girls = "checked";
                                else
                                    girls = "";
                            if (this.name=='boys')
                                if (this.checked)
                                    boys = "checked";
                                else
                                    boys = "";
                            if (this.name=='sel')
                                if (this.checked)
                                    sel = "checked";
                                else
                                    sel = "";
                            if (this.name=='sind')
                                if (this.checked)
                                    sind = "checked";
                                else
                                    sind = "";
                            });
                            
                        $(this).find(':text').each(function(){   
                            if (this.name=='pnum')
                                pnum = this.value;
                            if (this.name=='snum')
                                snum = this.value;
                        });  
                        
                        var DisplayedLocs = [];
                        var ind = 0;
                        // get the location details for all rows in table
                        $('#HeadlineStats').find('tr').each(function(){
                            $(this).find('.LocClass').each(function(){
                                DisplayedLocs[ind] = $(this).html();
                                ind +=1;
                            });
                        });
                        
                        var schConfigData = {
                            pcom: pcom,
                            prc: prc,
                            pcofe: pcofe,
                            poth: poth,
                            inf: inf,
                            jun: jun,
                            pind: pind,
                            pnum: pnum,
                            scom: scom,
                            src: src,
                            scofe: scofe,
                            soth: soth,
                            coed: coed,
                            girls: girls,
                            boys: boys,
                            sel: sel, 
                            sind: sind,
                            snum: snum,
                            locs: DisplayedLocs
                        };
                        // ajax call to update the school data displayed to meet set criteria
                        $.ajax({  
                            type: "GET",  
                            url: "changeschcriteria.php", 
                            dataType:'json',
                            data: schConfigData,  
                            success : function(result) 
                            {  
                                processSchools(result);
                            },  
                            error : function(result)
                            {
                                alert('An error has occured');
                            }
                        }); 
                        $("div#SchoolCriteria").dialog ("close");
                    }
                }]
        });
        return false;
});


$('.LocButton').click(function() {
        // bring up a map for the given row's location'
        //search for location data
        var data = { userloc : $("input#userloc").val()}; 
        
        $.ajax({  
            type: "GET",  
            url: "SearchLocations.php", 
            dataType: "json",
            data: data,  
            success : function(result) 
            {  
                processLocation(result);
            },  
            error : function(result)
            {
                alert('An error has occured');
            }
        }); 
      
        return false; //stop the link
     });

function processLocation(data) {
    showLocMap(data.latitude,data.longitude,data.userloc);
}


function processResponse(data) {
        
        var formattedRow = ""; 
   
        formattedRow = formattedRow +  "<tr class='RowClass'><td><input type='button' class='DeleteButton'></td>";
        formattedRow = formattedRow +  "<td><div class='LocClass'>" + data.town;
        formattedRow = formattedRow +  "<br>" + data.county ;
         formattedRow = formattedRow +  "</div><div id='controls'>"
        formattedRow = formattedRow +  "<input type='hidden' class='lat' value='" + data.latitude + "' />";
        formattedRow = formattedRow +  "<input type='hidden' class='long' value='" + data.longitude + "' />";
        formattedRow = formattedRow +  "<input type='button' value='Map' class='MapButton'/>"
        formattedRow = formattedRow +  "</div></td>";
        if (data.ward != ""){
            formattedRow = formattedRow + "<td>" + data.ward;
            formattedRow = formattedRow + ":<br>" + data.avprice + "</td>";
        } else {
            formattedRow = formattedRow + "<td></td>";
        }
        if (data.station != ""){
            formattedRow = formattedRow + "<td>" + data.station + "->" + data.terminus;
            formattedRow = formattedRow + "<br>" + data.durationterm + "mins</td>";
        } else {
            formattedRow = formattedRow + "<td></td>";
        }
        if (data.pschool != ""){
            // do a nested table to include all the schools info
            formattedRow = formattedRow + "<td class='PrimSchClass'><table class='schtab'>";
            for (var i=0; i<data.pnum; i++){
                formattedRow = formattedRow + "<tr>"; 
                formattedRow = formattedRow + "<td class='schtd'>" + data.pschool[i].pname;
                formattedRow = formattedRow + "</td><td class='schtd'>" + data.pschool[i].pdist + " km</td>";
                switch (data.pschool[i].pofsted){
                    case "1":
                        formattedRow = formattedRow + "<td class='sch1'>" + data.pschool[i].pofsted + "</td>";
                        break;
                    case "2":
                        formattedRow = formattedRow + "<td class='sch2'>" + data.pschool[i].pofsted + "</td>";
                        break;
                    case "3":
                        formattedRow = formattedRow + "<td class='sch3'>" + data.pschool[i].pofsted + "</td>";
                        break;
                    case "4":
                        formattedRow = formattedRow + "<td class='sch4'>" + data.pschool[i].pofsted + "</td>";
                        break;
                    default:
                        formattedRow = formattedRow + "<td class='schunc'></td>";
                        break;
                }
                formattedRow = formattedRow + "</tr>";
            }
            formattedRow = formattedRow + "</table></td>";
        } else {
            formattedRow = formattedRow + "<td></td>";
        }
        if (data.sschool != ""){
            // do a nested table to include all the schools info
            formattedRow = formattedRow + "<td class='SecSchClass'><table class='schtab'>";
            for (var i=0; i<data.snum; i++){
                formattedRow = formattedRow + "<tr>"; 
                formattedRow = formattedRow + "<td class='schtd'>" + data.sschool[i].sname;
                formattedRow = formattedRow + "</td><td class='schtd'>" + data.sschool[i].sdist + " km</td>";
                switch (data.sschool[i].sofsted){
                    case "1":
                        formattedRow = formattedRow + "<td class='sch1'>" + data.sschool[i].sofsted + "</td>";
                        break;
                    case "2":
                        formattedRow = formattedRow + "<td class='sch2'>" + data.sschool[i].sofsted + "</td>";
                        break;
                    case "3":
                        formattedRow = formattedRow + "<td class='sch3'>" + data.sschool[i].sofsted + "</td>";
                        break;
                    case "4":
                        formattedRow = formattedRow + "<td class='sch4'>" + data.sschool[i].sofsted + "</td>";
                        break;
                    default:
                        formattedRow = formattedRow + "<td class='schunc'></td>";
                        break;
                }
                formattedRow = formattedRow + "</tr>";
            }
            formattedRow = formattedRow + "</table></td>";
        } else {
            formattedRow = formattedRow + "<td></td>";
        }
            
        formattedRow = formattedRow + "</tr>";
 
     $('#HeadlineStats th').show();
     //append the row(s) returned to the table
     $('#HeadlineStats > tbody > tr:last').after(formattedRow);
     $('.DeleteButton').click(function() {
        //when the delete button is clicked, remove the whole row 
            //this line doesn't work any more? What does/did it do? Prob just needs deleting!
            //var auth = $(this).parent().parent().next().remove();
        $(this).parent().parent().remove();
     });
     $('.ExpandButton').click(function() {
        //when the expand button is clicked retrieve child locations
        var loc = $(this).parent().parent().children().text();
        expandLocation(loc);
     });
     $('.MapButton').click(function() {
        // bring up a map for the given row's location'
        var lat = $(this).parent().find(".lat").val();
        var lng = $(this).parent().find(".long").val();
        showMap(lat,lng);
     });
   }
   
function expandLocation(location) {
    
    alert(location);
}

function showMap(lat,lng) {
    initialiseMap();
    $( "#map_container" ).dialog( "open" );
    map.setCenter(new google.maps.LatLng(lat, lng), 10);
    plotPoint(lat,lng,'Location','<span class="gBubble"><b>Location</b></span>');
    return false;
}

function showLocMap(lat,lng,userloc) {
    initialiseLocMap();
    var data = $( "#map_loccontainer" ).data();   
    data.lat = lat;  
    data.lng = lng;
    data.userloc = userloc;

    $( "#map_loccontainer" ).dialog( "open" );
    map.setCenter(new google.maps.LatLng(lat, lng), 10);
    plotPoint(lat,lng,'Location','<span class="gBubble"><b>Location</b></span>');
    return false;
}

$( "#map_loccontainer" ).dialog({
            autoOpen:false,
            modal: true,
            width: 555,
            height: 400,
            resizeStop: function(event, ui) {google.maps.event.trigger(map, 'resize')  },
            open: function(event, ui) {google.maps.event.trigger(map, 'resize'); },  
            buttons : [{
                text: "OK",
                "class" : "OKButton",
                click : function() { 
                        //var userloc = $(this).data('userloc');
                        $("#map_loccontainer").dialog ("close");
                        //search for location data
                        var params = {  userloc : $(this).data('userloc'), 
                                        pcom: pcom,
                                        prc: prc,
                                        pcofe: pcofe,
                                        poth: poth,
                                        inf: inf,
                                        jun: jun,
                                        pind: pind,
                                        pnum: pnum,
                                        scom: scom,
                                        src: src,
                                        scofe: scofe,
                                        soth: soth,
                                        coed: coed,
                                        girls: girls,
                                        boys: boys,
                                        sel: sel, 
                                        sind: sind,
                                        snum: snum
                                    }; 
      
      
                        $.ajax({  
                                type: "GET",  
                                url: "SearchHeadlineStats.php", 
                                dataType: "json",
                                data: params,  
                                success : function(result) 
                                {  
                                    processResponse(result);
                                },  
                                error : function(result)
                                {
                                    alert('An error has occured');
                                }
                        }); 
      
                        return false; //stop the link
                    }
                }]
        });  

$( "#map_container" ).dialog({
            autoOpen:false,
            modal: true,
            width: 555,
            height: 400,
            resizeStop: function(event, ui) {google.maps.event.trigger(map, 'resize')  },
            open: function(event, ui) {google.maps.event.trigger(map, 'resize'); }      
        });  
        
$(  "input:submit,input:button, a, button", "#controls" ).button();

}); // end ready

function initialiseMap() 
    {      
    
        var latlng = new google.maps.LatLng(coords.lat, coords.lng);
        var myOptions = {
          zoom: 13,
          center: latlng,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
       map = new google.maps.Map(document.getElementById("map_canvas"),  myOptions);                         
    }  

function initialiseLocMap() 
    {      
    
        var latlng = new google.maps.LatLng(coords.lat, coords.lng);
        var myOptions = {
          zoom: 13,
          center: latlng,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          overviewMapControl: true,
          overviewMapControlOptions: {opened: true}
        };
       map = new google.maps.Map(document.getElementById("map_loccanvas"),  myOptions);
       
    }   
   
function plotPoint(srcLat,srcLon,title,popUpContent,markerIcon)
    {
            var myLatlng = new google.maps.LatLng(srcLat, srcLon);            
            var marker = new google.maps.Marker({
                  position: myLatlng, 
                  map: map, 
                  title:title,
                  icon: markerIcon
              });
              markersArray.push(marker);
            var infowindow = new google.maps.InfoWindow({
                content: popUpContent
            });
              google.maps.event.addListener(marker, 'click', function() {
              infowindow.open(map,marker);
            });                                          
    }



   
