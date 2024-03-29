<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--
 Copyright 2008 Google Inc. 
 Licensed under the Apache License, Version 2.0: 
 http://www.apache.org/licenses/LICENSE-2.0 
 -->
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps JavaScript API Example</title>
    <script type="text/javascript">
    //<![CDATA[
    var map;

    function loadMap() {
      map = new GMap2(document.getElementById("map"));
      map.setCenter(new GLatLng(37.4419, -122.1419), 6);
      map.addOverlay(new GMarker(map.getCenter()));
    }

    function loadScript() {
      var script = document.createElement("script");
      script.type = "text/javascript";
      script.src = "http://maps.google.com/maps?file=api&v=2&key=ABQIAAAA-O3c-Om9OcvXMOJXreXHAxQGj0PqsCtxKvarsoS-iqLdqZSKfxS27kJqGZajBjvuzOBLizi931BUow&async=2&callback=loadMap";
      document.body.appendChild(script);
    }

    //]]>
    </script>
  </head>
  <body onload="">
    <div id="map" style="width: 500px; height: 300px"></div>
    <input type="button" value="load script + map" onclick="loadScript();"/>
  </body>
</html>