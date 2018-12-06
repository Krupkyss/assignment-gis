-- FUNCTION: public."GetRunWays"(double precision, double precision)

-- DROP FUNCTION public."GetRunWays"(double precision, double precision);

CREATE OR REPLACE FUNCTION public."GetRunWays"(
	longitude double precision,
	latitude double precision)
    RETURNS TABLE(geojson json) 
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

WITH highwaysColors AS (
	SELECT highway, color
	FROM (
		VALUES 	('footway', '#2e59f9'), 
				('bridleway', '#d06344'),
				('steps', '#e90533'),
				('path', '#fb375f'),
				('living_street', '#164c0f'),
				('pedestrian', '#03829b')
	) highwaysColors (highway, color)
) 
select json_build_object(
  'type',       'Feature',
  'geometry',    way::json,
  'properties',  json_build_object(
  		'color', (SELECT color 
				  FROM highwaysColors hc 
				  WHERE hc.highway = sub.highway)
  )
) AS geojson
FROM(		
	SELECT line.highway as highway, ST_AsGeoJSON(ST_Transform(line.way, 4326)) AS way
	FROM planet_osm_line AS line
	WHERE line.highway IN('footway', 'bridleway', 'steps', 'path', 'living_street', 'pedestrian')
	AND ST_DWithin(ST_Transform(
		line.way, 4326), 
		ST_GeogFromText('SRID=4326;POINT(' || $1 || ' ' || $2 || ')'), 500)) AS sub							 

$BODY$;

ALTER FUNCTION public."GetRunWays"(double precision, double precision)
    OWNER TO postgres;
