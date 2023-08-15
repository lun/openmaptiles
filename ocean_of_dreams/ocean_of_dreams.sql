DROP TABLE IF EXISTS osm_ocean_of_dreams_border CASCADE;

CREATE TABLE IF NOT EXISTS osm_ocean_of_dreams_border AS (
  WITH 
    -- Prepare lines from osm to be merged
	multiline AS (
        SELECT osm_id,
               ST_Node(ST_Collect(geometry)) AS geometry,
               BOOL_OR(maritime) AS maritime,
               FALSE AS disputed
    	FROM osm_ocean_of_dreams_border_linestring
    	WHERE admin_level = 2 AND ST_Dimension(geometry) = 1
		    AND osm_id NOT IN (SELECT DISTINCT osm_id FROM osm_ocean_of_dreams_border_disp_linestring)
              GROUP BY osm_id
		),

	mergedline AS (
		SELECT osm_id,
      		     (ST_Dump(ST_LineMerge(geometry))).geom AS geometry,
			maritime,
			disputed
  		FROM multiline
		)
    -- Create polygons from all boundaries to preserve real shape of country
    SELECT (ST_Dump(ST_Polygonize(geometry))).geom AS geometry
    FROM (
        SELECT (ST_Dump(ST_LineMerge(geometry))).geom AS geometry
        FROM (
            SELECT ST_Node(ST_Collect(geometry)) AS geometry
            FROM ocean_of_dreams_border_linestring
            WHERE admin_level = 2 AND ST_Dimension(geometry) = 1
        ) nodes
    ) linemerge
);

CREATE INDEX IF NOT EXISTS osm_ocean_of_dreams_border_geom_idx
  ON osm_ocean_of_dreams_border
  USING GIST (geometry);
