-- ne_50m_urban_areas
-- etldoc: ne_50m_urban_areas ->  ne_50m_urban_areas_gen_z5
DROP MATERIALIZED VIEW IF EXISTS ne_50m_urban_areas_gen_z5 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_urban_areas_gen_z5 AS
(
SELECT
       NULL::bigint AS osm_id,
       ST_Simplify(geometry, ZRes(7)) as geometry,
       'urban'::text AS residential,
       scalerank
FROM ne_50m_urban_areas
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_urban_areas_gen_z5_idx ON ne_50m_urban_areas_gen_z5 USING gist (geometry);

-- etldoc: ne_50m_urban_areas_gen_z5 ->  ne_50m_urban_areas_gen_z4
DROP MATERIALIZED VIEW IF EXISTS ne_50m_urban_areas_gen_z4 CASCADE;
CREATE MATERIALIZED VIEW ne_50m_urban_areas_gen_z4 AS
(
SELECT
       osm_id,
       ST_Simplify(geometry, ZRes(6)) as geometry,
       residential
FROM ne_50m_urban_areas_gen_z5
WHERE scalerank <= 2
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS ne_50m_urban_areas_gen_z4_idx ON ne_50m_urban_areas_gen_z4 USING gist (geometry);

-- etldoc: layer_landuse_residential[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_landuse_residential |<z4> z4|<z5> z5|<z6> z6|<z7> z7|<z8> z8|<z9> z9|<z10> z10|<z11> z11|<z12> z12|<z13> z13|<z14> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_landuse_residential(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                osm_id   bigint,
                geometry geometry,
                subclass text
            )
AS
$$
SELECT osm_id,
       geometry,
       residential AS subclass
FROM (
         -- etldoc: ne_50m_urban_areas_gen_z4 -> layer_landuse_residential:z4
         SELECT osm_id,
                geometry,
                residential
         FROM ne_50m_urban_areas_gen_z4
         WHERE zoom_level = 4
         UNION ALL
         -- etldoc: ne_50m_urban_areas_gen_z5 -> layer_landuse_residential:z5
         SELECT osm_id,
                geometry,
                residential
         FROM ne_50m_urban_areas_gen_z5
         WHERE zoom_level = 5
         UNION ALL
         -- etldoc: osm_landuse_residential_polygon_gen_z6 -> layer_landuse_residential:z6
         SELECT osm_id,
                geometry,
                residential
         FROM osm_landuse_residential_polygon_gen_z6
         WHERE zoom_level = 6
         UNION ALL
         -- etldoc: osm_landuse_residential_polygon_gen_z7 -> layer_landuse_residential:z7
         SELECT osm_id,
                geometry,
                residential
         FROM osm_landuse_residential_polygon_gen_z7
         WHERE zoom_level = 7
         UNION ALL
         -- etldoc: osm_landuse_residential_polygon_gen_z8 -> layer_landuse_residential:z8
         SELECT osm_id,
                geometry,
                residential
         FROM osm_landuse_residential_polygon_gen_z8
         WHERE zoom_level = 8
         UNION ALL
         -- etldoc: osm_landuse_residential_polygon_gen_z9 -> layer_landuse_residential:z9
         SELECT osm_id,
                geometry,
                residential
         FROM osm_landuse_residential_polygon_gen_z9
         WHERE zoom_level = 9
         UNION ALL
         -- etldoc: osm_landuse_residential_polygon_gen_z10 -> layer_landuse_residential:z10
         SELECT osm_id,
                geometry,
                residential
         FROM osm_landuse_residential_polygon_gen_z10
         WHERE zoom_level = 10
         UNION ALL
         -- etldoc: osm_landuse_residential_polygon_gen_z11 -> layer_landuse_residential:z11
         SELECT osm_id,
                geometry,
                residential
         FROM osm_landuse_residential_polygon_gen_z11
         WHERE zoom_level = 11
         UNION ALL
         -- etldoc: osm_landuse_residential_polygon_gen_z12 -> layer_landuse_residential:z12
         SELECT osm_id,
                geometry,
                residential
         FROM osm_landuse_residential_polygon_gen_z12
         WHERE zoom_level = 12
         UNION ALL
         -- etldoc: osm_landuse_residential_polygon_gen_z13 -> layer_landuse_residential:z13
         SELECT osm_id,
                geometry,
                residential
         FROM osm_landuse_residential_polygon_gen_z13
         WHERE zoom_level = 13
         UNION ALL
         -- etldoc: osm_landuse_residential_polygon -> layer_landuse_residential:z14
         SELECT osm_id,
                geometry,
                residential
         FROM osm_landuse_residential_polygon
         WHERE zoom_level >= 14
     ) AS zoom_levels
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
