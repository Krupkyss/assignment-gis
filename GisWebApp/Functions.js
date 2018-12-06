function InitializeLayers() {
    InitRunWays();
    InitWayInLength();
    InitGyms();
    InitCurrentPosition();
}

function InitRunWays() {
    map.addSource('runWays', {
        'type': 'geojson',
        'data': {
            "type": "Feature",
            "geometry": {
                "type": "LineString",
                "coordinates": []
            }
        }
    });
    map.addLayer({
        'id': 'runWays',
        'type': 'line',
        'source': 'runWays',
        'layout': {
            'line-join': 'round',
            'line-cap': 'round'
        },
        'paint': {
            'line-width': 3,
            'line-color': ['get', 'color']
        }
    });
}

function InitWayInLength() {
    map.addSource('wayInLength', {
        'type': 'geojson',
        'data': {
            "type": "Feature",
            "geometry": {
                "type": "LineString",
                "coordinates": []
            }
        }
    });
    map.addLayer({
        'id': 'wayInLength',
        'type': 'line',
        'source': 'wayInLength',
        'layout': {
            'line-join': 'round',
            'line-cap': 'round'
        },
        'paint': {
            'line-width': 5,
            'line-color': ['get', 'color']
        }
    });
}

function InitGyms() {
    map.addSource('gyms', {
        'type': 'geojson',
        'data': {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": []
            }
        }
    });
    map.addLayer({
        'id': 'gyms',
        'type': 'symbol',
        'source': 'gyms',
        "layout": {
            "icon-image": "playground-15",
            "icon-size": 3
        }
    });
}

function InitCurrentPosition() {
    map.addSource('currentPositionSource', {
        'type': 'geojson',
        'data': {
            "type": "Point",
            "coordinates": [17.06258, 48.15956]
        }
    });
    map.addLayer({
        "id": "currentPosition",
        "type": "symbol",
        "source": "currentPositionSource",
        "layout": {
            "icon-image": "marker-15",
            "icon-size": 1.5
        }
    });
}

function GetRunWays() {
    $.ajax({
        type: "POST",
        async: true,
        processData: true,
        cache: false,
        url: 'Map.aspx/GetRunWays',
        data: '{longitude:"' + document.getElementById('longStart').value + '", latitude:"' + document.getElementById('latStart').value + '"}',
        contentType: 'application/json; charset=utf-8',
        dataType: "json",
        success: function (data) {
            try {
                var geojson = jQuery.parseJSON(data.d);

                map.getSource('runWays').setData(geojson);
                
                data = {
                    "type": "Point",
                    "coordinates": [
                        document.getElementById('longStart').value,
                        document.getElementById('latStart').value
                    ]
                };
                map.getSource('currentPositionSource').setData(data);
            }
            catch (err) {
                alert(err.message);
                alert(err.responseText);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('An error occurred... Look at the console (F12 or Ctrl+Shift+I, Console tab) for more information!');

            $('#result').html('<p>status code: ' + jqXHR.status + '</p><p>errorThrown: ' + errorThrown + '</p><p>jqXHR.responseText:</p><div>' + jqXHR.responseText + '</div>');
            console.log('jqXHR:');
            console.log(jqXHR);
            console.log('textStatus:');
            console.log(textStatus);
            console.log('errorThrown:');
            console.log(errorThrown);
        }
    });
}

function GetWayInLength() {
    $.ajax({
        type: "POST",
        async: true,
        processData: true,
        cache: false,
        url: 'Map.aspx/GetWayInLength',
        data: '{longStart:"' + document.getElementById('longStart').value + '", latStart:"' + document.getElementById('latStart').value + '", length:"' + document.getElementById('length').value + '"}',
        contentType: 'application/json; charset=utf-8',
        dataType: "json",
        beforeSend: function () {
            alert("Confirm to start finding runways. It may take a while, please wait.");
        },
        success: function (data) {
            try {
                var geojson = jQuery.parseJSON(data.d);

                map.getSource('wayInLength').setData(geojson);

                data = {
                    "type": "Point",
                    "coordinates": [
                        document.getElementById('longStart').value,
                        document.getElementById('latStart').value
                    ]
                };
                map.getSource('currentPositionSource').setData(data);
            }
            catch (err) {
                alert(err.message);
                alert(err.responseText);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('An error occurred... Look at the console (F12 or Ctrl+Shift+I, Console tab) for more information!');

            $('#result').html('<p>status code: ' + jqXHR.status + '</p><p>errorThrown: ' + errorThrown + '</p><p>jqXHR.responseText:</p><div>' + jqXHR.responseText + '</div>');
            console.log('jqXHR:');
            console.log(jqXHR);
            console.log('textStatus:');
            console.log(textStatus);
            console.log('errorThrown:');
            console.log(errorThrown);
        }
    });
}

function GetGyms() {
    $.ajax({
        type: "POST",
        async: true,
        processData: true,
        cache: false,
        url: 'Map.aspx/GetGyms',
        data: '{longitude:"' + document.getElementById('longStart').value + '", latitude:"' + document.getElementById('latStart').value + '"}',
        contentType: 'application/json; charset=utf-8',
        dataType: "json",
        success: function (data) {
            try {
                var geojson = jQuery.parseJSON(data.d);

                map.getSource('gyms').setData(geojson);

                data = {
                    "type": "Point",
                    "coordinates": [
                        document.getElementById('longStart').value,
                        document.getElementById('latStart').value
                    ]
                };
                map.getSource('currentPositionSource').setData(data);
            }
            catch (err) {
                alert(err.message);
                alert(err.responseText);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('An error occurred... Look at the console (F12 or Ctrl+Shift+I, Console tab) for more information!');

            $('#result').html('<p>status code: ' + jqXHR.status + '</p><p>errorThrown: ' + errorThrown + '</p><p>jqXHR.responseText:</p><div>' + jqXHR.responseText + '</div>');
            console.log('jqXHR:');
            console.log(jqXHR);
            console.log('textStatus:');
            console.log(textStatus);
            console.log('errorThrown:');
            console.log(errorThrown);
        }
    });
}

function ChangeVisibility() {
    geojson = {
            "type": "Feature",
            "geometry": {
                "type": "LineString",
                "coordinates": []
            }
    };
    map.getSource('runWays').setData(geojson);
    map.getSource('wayInLength').setData(geojson);
    map.getSource('gyms').setData(geojson);
}

function Zoom() {
    map.zoomTo(19,
        {
             duration: 9000
        });
}

function SetCurrentPosition(e) {
    document.getElementById("longStart").value = e.lngLat.lng;
    document.getElementById("latStart").value = e.lngLat.lat;

    data = {
        "type": "Point",
        "coordinates": [
            e.lngLat.lng,
            e.lngLat.lat
        ]
    };
    map.getSource('currentPositionSource').setData(data);
}
