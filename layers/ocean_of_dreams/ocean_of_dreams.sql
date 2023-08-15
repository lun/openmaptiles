DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z0;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z1;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z2;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z3;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z4;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z5;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z6;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z7;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z8;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z9;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z10;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z11;
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_of_dreams_border_z12;


CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z12 AS
(
    SELECT ST_Simplify(geometry, ZRes(14))
    FROM osm_ocean_of_dreams_border
);
CREATE INDEX ON osm_ocean_of_dreams_border_z12 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z11 AS
(
    SELECT ST_Simplify(geometry, ZRes(13))
    FROM osm_ocean_of_dreams_border_z12
);
CREATE INDEX ON osm_ocean_of_dreams_border_z11 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z10 AS
(
    SELECT ST_Simplify(geometry, ZRes(12))
    FROM osm_ocean_of_dreams_border_z11
);
CREATE INDEX ON osm_ocean_of_dreams_border_z10 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z9 AS
(
    SELECT ST_Simplify(geometry, ZRes(11))
    FROM osm_ocean_of_dreams_border_z10
);
CREATE INDEX ON osm_ocean_of_dreams_border_z9 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z8 AS
(
    SELECT ST_Simplify(geometry, ZRes(10))
    FROM osm_ocean_of_dreams_border_z9
);
CREATE INDEX ON osm_ocean_of_dreams_border_z8 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z7 AS
(
    SELECT ST_Simplify(geometry, ZRes(9))
    FROM osm_ocean_of_dreams_border_z8
);
CREATE INDEX ON osm_ocean_of_dreams_border_z7 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z6 AS
(
    SELECT ST_Simplify(geometry, ZRes(8))
    FROM osm_ocean_of_dreams_border_z7
);
CREATE INDEX ON osm_ocean_of_dreams_border_z6 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z5 AS
(
    SELECT ST_Simplify(geometry, ZRes(7))
    FROM osm_ocean_of_dreams_border_z6
);
CREATE INDEX ON osm_ocean_of_dreams_border_z5 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z4 AS
(
    SELECT ST_Simplify(geometry, ZRes(6))
    FROM osm_ocean_of_dreams_border_z5
);
CREATE INDEX ON osm_ocean_of_dreams_border_z4 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z3 AS
(
    SELECT ST_Simplify(geometry, ZRes(5))
    FROM osm_ocean_of_dreams_border_z4
);
CREATE INDEX ON osm_ocean_of_dreams_border_z3 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z2 AS
(
    SELECT ST_Simplify(geometry, ZRes(4))
    FROM osm_ocean_of_dreams_border_z3
);
CREATE INDEX ON osm_ocean_of_dreams_border_z2 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z1 AS
(
    SELECT ST_Simplify(geometry, ZRes(3))
    FROM osm_ocean_of_dreams_border_z2
);
CREATE INDEX ON osm_ocean_of_dreams_border_z1 USING gist(geometry);

CREATE MATERIALIZED VIEW osm_ocean_of_dreams_border_z0 AS
(
    SELECT ST_Simplify(geometry, ZRes(2))
    FROM osm_ocean_of_dreams_border_z1
);
CREATE INDEX ON osm_ocean_of_dreams_border_z0 USING gist(geometry);


CREATE OR REPLACE FUNCTION layer_ocean_of_dreams(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                geometry     geometry
            )
AS
$$
SELECT geometry
FROM (
         SELECT *
         FROM osm_ocean_of_dreams_border__z0
         WHERE zoom_level = 0
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z1
         WHERE zoom_level = 1
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z2
         WHERE zoom_level = 2
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z3
         WHERE zoom_level = 3
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z4
         WHERE zoom_level = 4
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z5
         WHERE zoom_level = 5
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z6
         WHERE zoom_level = 6
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z7
         WHERE zoom_level = 7
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z8
         WHERE zoom_level = 8
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z9
         WHERE zoom_level = 9
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z10
         WHERE zoom_level = 10
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z11
         WHERE zoom_level = 11
         UNION ALL
         SELECT *
         FROM osm_ocean_of_dreams_border_z12
         WHERE zoom_level >= 12
     ) AS zoom_levels
WHERE geometry && bbox;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
