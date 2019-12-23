-- etldoc: ne_50m_urban_areas -> landuse_residential_z4
CREATE OR REPLACE VIEW landuse_residential_z4 AS (
    SELECT NULL::bigint AS osm_id, geometry, 'urban'::text AS residential, scalerank
    FROM ne_50m_urban_areas
    WHERE scalerank <= 2
);

-- etldoc: ne_50m_urban_areas -> landuse_residential_z5
CREATE OR REPLACE VIEW landuse_residential_z5 AS (
    SELECT NULL::bigint AS osm_id, geometry, 'urban'::text AS residential, scalerank
    FROM ne_50m_urban_areas
);

-- etldoc: osm_landuse_residential_polygon_gen7 -> landuse_residential_z6
CREATE OR REPLACE VIEW landuse_residential_z6 AS (
    SELECT osm_id, geometry, residential, NULL::int as scalerank
    FROM osm_landuse_residential_polygon_gen7
);

-- etldoc: osm_landuse_residential_polygon_gen6 -> landuse_residential_z8
CREATE OR REPLACE VIEW landuse_residential_z8 AS (
    SELECT osm_id, geometry, residential, NULL::int as scalerank
    FROM osm_landuse_residential_polygon_gen6
);

-- etldoc: osm_landuse_residential_polygon_gen5 -> landuse_residential_z9
CREATE OR REPLACE VIEW landuse_residential_z9 AS (
    SELECT osm_id, geometry, residential, NULL::int as scalerank
    FROM osm_landuse_residential_polygon_gen5
);

-- etldoc: osm_landuse_residential_polygon_gen4 -> landuse_residential_z10
CREATE OR REPLACE VIEW landuse_residential_z10 AS (
    SELECT osm_id, geometry, residential, NULL::int as scalerank
    FROM osm_landuse_residential_polygon_gen4
);

-- etldoc: osm_landuse_residential_polygon_gen3 -> landuse_residential_z11
CREATE OR REPLACE VIEW landuse_residential_z11 AS (
    SELECT osm_id, geometry, residential, NULL::int as scalerank
    FROM osm_landuse_residential_polygon_gen3
);

-- etldoc: osm_landuse_residential_polygon_gen2 -> landuse_residential_z12
CREATE OR REPLACE VIEW landuse_residential_z12 AS (
    SELECT osm_id, geometry, residential, NULL::int as scalerank
    FROM osm_landuse_residential_polygon_gen2
);

-- etldoc: osm_landuse_residential_polygon_gen1 -> landuse_residential_z13
CREATE OR REPLACE VIEW landuse_residential_z13 AS (
    SELECT osm_id, geometry, residential, NULL::int as scalerank
    FROM osm_landuse_residential_polygon_gen1
);

-- etldoc: osm_landuse_residential_polygon -> landuse_residential_z14
CREATE OR REPLACE VIEW landuse_residential_z14 AS (
    SELECT osm_id, geometry, residential, NULL::int as scalerank
    FROM osm_landuse_residential_polygon
);

-- etldoc: layer_landuse_residential[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_landuse_residential |<z4> z4|<z5>z5|<z6>z6|<z7>z7| <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11|<z12> z12|<z13> z13|<z14> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_landuse_residential(bbox geometry, zoom_level int)
RETURNS TABLE(osm_id bigint, geometry geometry, subclass text) AS $$
    SELECT osm_id, geometry, residential AS subclass
        FROM (
        -- etldoc: landuse_residential_z4 -> layer_landuse_residential:z4
        SELECT * FROM landuse_residential_z4
        WHERE zoom_level = 4
        UNION ALL
        -- etldoc: landuse_residential_z5 -> layer_landuse_residential:z5
        SELECT * FROM landuse_residential_z5
        WHERE zoom_level = 5
        UNION ALL
        -- etldoc: landuse_residential_z6 -> layer_landuse_residential:z6
        -- etldoc: landuse_residential_z6 -> layer_landuse_residential:z7
        SELECT * FROM landuse_residential_z6 WHERE zoom_level BETWEEN 6 AND 7
        UNION ALL
        -- etldoc: landuse_residential_z8 -> layer_landuse_residential:z8
        SELECT * FROM landuse_residential_z8 WHERE zoom_level = 8
        UNION ALL
        -- etldoc: landuse_residential_z9 -> layer_landuse_residential:z9
        SELECT * FROM landuse_residential_z9 WHERE zoom_level = 9
        UNION ALL
        -- etldoc: landuse_residential_z10 -> layer_landuse_residential:z10
        SELECT * FROM landuse_residential_z10 WHERE zoom_level = 10
        UNION ALL
        -- etldoc: landuse_residential_z11 -> layer_landuse_residential:z11
        SELECT * FROM landuse_residential_z11 WHERE zoom_level = 11
        UNION ALL
        -- etldoc: landuse_residential_z12 -> layer_landuse_residential:z12
        SELECT * FROM landuse_residential_z12 WHERE zoom_level = 12
        UNION ALL
        -- etldoc: landuse_residential_z13 -> layer_landuse_residential:z13
        SELECT * FROM landuse_residential_z13 WHERE zoom_level = 13
        UNION ALL
        -- etldoc: landuse_residential_z14 -> layer_landuse_residential:z14
        SELECT * FROM landuse_residential_z14 WHERE zoom_level >= 14
    ) AS zoom_levels
    WHERE geometry && bbox;
$$ LANGUAGE SQL IMMUTABLE;
