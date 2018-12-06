-- FUNCTION: public."GetWayInLength"(double precision, double precision, integer)

-- DROP FUNCTION public."GetWayInLength"(double precision, double precision, integer);

CREATE OR REPLACE FUNCTION public."GetWayInLength"(
	longstart double precision,
	latstart double precision,
	length integer)
    RETURNS TABLE(geojson json) 
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

WITH RECURSIVE backtracking(gid, x1, y1, x2, y2, length_m) AS (
	SELECT ARRAY[CAST(1 AS BIGINT)], w.x1, w.y1, w.x2, w.y2, w.length_m	
	FROM ww w
	WHERE x1 = (SELECT x1 FROM p1) and y1 = (SELECT y1 FROM p1)

	UNION ALL
	
	SELECT b.gid || w.gid, w.x1, w.y1, w.x2, w.y2, (w.length_m + b.length_m)
	FROM backtracking b
	JOIN ww w ON b.x2 = w.x1 AND b.y2 = w.y1
	WHERE not w.gid = ANY(b.gid) AND
	b.length_m < $3 AND
	array_length(b.gid, 1) < 40
),
ww AS (
	SELECT * 
	FROM ways
	WHERE osm_id in (
			select osm_id 
			from planet_osm_line 
			WHERE  ST_DWithin(ST_Transform(
			way, 4326), 
			ST_GeogFromText('SRID=4326;POINT(' || $1 || ' ' || $2 || ')'), 1000))
),
p1 AS (
	SELECT x1, y1, x2, y2
	FROM ww
	ORDER BY ST_DISTANCE(the_geom, ST_GEOMFROMEWKT('SRID=4326;POINT(' || $1 || ' ' || $2 || ')')) 
	LIMIT 1)
SELECT json_build_object(
  'type',       'Feature',
  'geometry',    way::json,
  'properties',  json_build_object(
  		'color', '#e90533'
  )
) AS geojson
FROM(
	select ST_AsGeoJSON(st_linemerge(st_union(w.the_geom))) AS way
	from ways w
	where w.gid = any(
		select unnest(sub.gid)
		from (
			select b.gid
			from backtracking b
			where b.x2 = (SELECT x2 FROM p1) and b.y2 = (SELECT y2 FROM p1)
			order by b.length_m desc
			limit 1
		) sub
	)
) as sub2;

$BODY$;

ALTER FUNCTION public."GetWayInLength"(double precision, double precision, integer)
    OWNER TO postgres;
