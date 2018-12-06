<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Map.aspx.cs" Inherits="GisWebApp.Map" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>GIS</title>
    <meta name="viewport" content="initial-scale=1,maximum-scale=1,user-scalable=no" />

    <link rel="stylesheet" type="text/css" href="https://api.mapbox.com/mapbox-gl-js/v0.50.0/mapbox-gl.css" />
    <link rel="stylesheet" type="text/css" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="style.css" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css" />


    <script type="text/javascript" src="https://api.mapbox.com/mapbox-gl-js/v0.50.0/mapbox-gl.js"></script>
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script type="text/javascript" src="Functions.js"></script>
    <script type="text/javascript" src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>

</head>
<body id="">

    <div id="menu">
        <div class="text-center">
            <h3>GO FOR RUN</h3>
        </div>
        
        <hr />

        <div class="row" >
            <div class="col-md-2">
            </div>
            <div class="col-md-7">
                <div class="input-group">

                    <div class="">
                        <label class="control-label" for="latitude"><b>Latitude</b></label>
                        <div class="controls">
                            <input id="latStart" type="text" name="latStart" placeholder="00.000000" />
                        </div>
                    </div>

                    <div class="">
                        <label class="control-label" for="longitude"><b>Longitude</b></label>
                        <div class="controls">
                            <input id="longStart" type="text" name="longStart" placeholder="00.0000000" />
                        </div>
                    </div>

                    <div class="control-group">
                        <div class="controls">
                            <button id="runWays" class="btn btn-success">Show run ways</button>
                        </div>
                    </div>
                    <div class="control-group">
                        <div class="controls">
                            <button id="showGyms" class="btn btn-success">Show nearby Gyms</button>
                        </div>
                    </div>
                   
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-2"></div>
            <div class="col-md-7">
                <div class="input-group">
                    <div class="">
                        <label class="control-label" for="longitude">Length <i>(m)</i></label>
                        <div class="controls">
                            <input id="length" type="text" name="length" placeholder="2000" />
                        </div>
                    </div>
                    <%--<p class="text-right"><i>* meter (m)</i></p>--%>

                    <div class="control-group">
                        <div class="controls">
                            <button id="wayInLength" class="btn btn-success">Show ways in length</button>
                        </div>
                    </div>
                    
                </div>
            </div>
        </div>

        <div id="legend">
            <h3>Advanced options</h3>
            <hr />
        </div>

        <div class="row">
            <div class="col-md-2"></div>
            <div class="col-md-7">
                <div class="control-group">
                    <div class="controls">
                        <button id="zoom" class="btn btn-success">Zoom</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-2"></div>
            <div class="col-md-7">
                <div class="control-group">
                    <div class="controls">
                        <button id="visibility" class="btn btn-success">Clear map</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="map"></div>

    <script type="text/javascript">               

        mapboxgl.accessToken = 'pk.eyJ1Ijoia3J1cGt5c3MiLCJhIjoiY2pucnFhaWl6MDd2cDN2bGs4d3VnaWE4ZiJ9.nvr-rBGWYzWcRsXgWvJkYA';
        var map = new mapboxgl.Map({
            container: 'map',
            style: 'mapbox://styles/mapbox/bright-v9',
            center: [17.06258, 48.15956],
            zoom: 13
        });

        map.on('load', function () {
            InitializeLayers();
        });

        map.on('mouseup', function (e) {
            SetCurrentPosition(e);
        });

        map.addControl(new mapboxgl.NavigationControl());
        map.addControl(new mapboxgl.GeolocateControl({
            positionOptions: { enableHighAccuracy: true },
            trackUserLocation: true
        }));
        
        document.getElementById('runWays').addEventListener('click', function () {
            GetRunWays();
        });

        document.getElementById('wayInLength').addEventListener('click', function () {
            GetWayInLength();
        });

        document.getElementById('showGyms').addEventListener('click', function () {
            GetGyms();
        });

        document.getElementById('visibility').addEventListener('click', function () {
            ChangeVisibility();
        });

        document.getElementById('zoom').addEventListener('click', function () {
            Zoom();
        });
    </script>
</body>
</html>
