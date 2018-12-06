-- FUNCTION: public."GetGyms"(double precision, double precision)

-- DROP FUNCTION public."GetGyms"(double precision, double precision);

CREATE OR REPLACE FUNCTION public."GetGyms"(
	longitude double precision,
	latitude double precision)
    RETURNS TABLE(geojson json) 
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

SELECT json_build_object( 
	'type', 'Feature', 
	'geometry', ST_AsGeoJSON(sub.way)::json
) AS geojson
FROM ( 
	SELECT ST_Transform(point.way, 4326) AS way
	FROM planet_osm_point point
	WHERE leisure = 'fitness_centre' OR amenity = 'gym'  
	UNION  
	SELECT ST_Transform(ST_Centroid(polygon.way), 4326) AS way
	FROM planet_osm_polygon polygon
	WHERE leisure = 'fitness_centre' OR amenity = 'gym' 
	) AS sub 
WHERE ST_DWithin(sub.way::GEOGRAPHY, 
	ST_GeogFromText('SRID=4326;POINT(' || $1 || ' ' || $2 || ')'), 1000)

$BODY$;

ALTER FUNCTION public."GetGyms"(double precision, double precision)
    OWNER TO postgres;
