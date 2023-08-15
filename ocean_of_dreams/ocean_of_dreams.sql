DROP TABLE IF EXISTS osm_ocean_of_dreams_border CASCADE;

CREATE TABLE IF NOT EXISTS osm_ocean_of_dreams_border AS (
    -- Create polygons from all boundaries to preserve real shape of country
    SELECT (ST_Dump(ST_Polygonize(geometry))).geom AS geometry
    FROM (
        SELECT (ST_Dump(ST_LineMerge(geometry))).geom AS geometry
        FROM (
            SELECT ST_Node(ST_Collect(geometry)) AS geometry
            FROM osm_ocean_of_dreams_border_linestring
            WHERE admin_level = 2 AND ST_Dimension(geometry) = 1
        ) nodes
    ) linemerge
);

CREATE INDEX IF NOT EXISTS osm_ocean_of_dreams_border_geom_idx
  ON osm_ocean_of_dreams_border
  USING GIST (geometry);
