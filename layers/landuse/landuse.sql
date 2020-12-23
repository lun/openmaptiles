-- etldoc: layer_landuse[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_landuse |<z4> z4|<z5> z5|<z6> z6|<z7> z7|<z8> z8|<z9> z9|<z10> z10|<z11> z11|<z12> z12|<z13> z13|<z14> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_landuse(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                osm_id   bigint,
                geometry geometry,
                class    text
            )
AS
$$
SELECT osm_id,
       geometry,
       COALESCE(
               NULLIF(landuse, ''),
               NULLIF(amenity, ''),
               NULLIF(leisure, ''),
               NULLIF(tourism, ''),
               NULLIF(place, ''),
               NULLIF(waterway, '')
           ) AS class
FROM (
         -- etldoc: osm_landuse_polygon_gen_z9 -> layer_landuse:z9
         SELECT osm_id,
                geometry,
                landuse,
                amenity,
                leisure,
                tourism,
                place,
                waterway
         FROM osm_landuse_polygon_gen_z9
         WHERE zoom_level = 9
         UNION ALL
         -- etldoc: osm_landuse_polygon_gen_z10 -> layer_landuse:z10
         SELECT osm_id,
                geometry,
                landuse,
                amenity,
                leisure,
                tourism,
                place,
                waterway
         FROM osm_landuse_polygon_gen_z10
         WHERE zoom_level = 10
         UNION ALL
         -- etldoc: osm_landuse_polygon_gen_z11 -> layer_landuse:z11
         SELECT osm_id,
                geometry,
                landuse,
                amenity,
                leisure,
                tourism,
                place,
                waterway
         FROM osm_landuse_polygon_gen_z11
         WHERE zoom_level = 11
         UNION ALL
         -- etldoc: osm_landuse_polygon_gen_z12 -> layer_landuse:z12
         SELECT osm_id,
                geometry,
                landuse,
                amenity,
                leisure,
                tourism,
                place,
                waterway
         FROM osm_landuse_polygon_gen_z12
         WHERE zoom_level = 12
         UNION ALL
         -- etldoc: osm_landuse_polygon_gen_z13 -> layer_landuse:z13
         SELECT osm_id,
                geometry,
                landuse,
                amenity,
                leisure,
                tourism,
                place,
                waterway
         FROM osm_landuse_polygon_gen_z13
         WHERE zoom_level = 13
         UNION ALL
         -- etldoc: osm_landuse_polygon -> layer_landuse:z14
         SELECT osm_id,
                geometry,
                landuse,
                amenity,
                leisure,
                tourism,
                place,
                waterway
         FROM osm_landuse_polygon
         WHERE zoom_level >= 14
     ) AS zoom_levels
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
