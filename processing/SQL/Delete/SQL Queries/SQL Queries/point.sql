-- Creates a layer for points.

-----------------------------------------------------------------
-- CREATE THE TABLE --
-----------------------------------------------------------------

CREATE TABLE point (
id NUMBER(38) NOT NULL,
name VARCHAR2(32),
shape MDSYS.SDO_GEOMETRY);

-----------------------------------------------------------------
-- INSERT SHAPES --
-----------------------------------------------------------------

INSERT INTO point VALUES(
1,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 11, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
2,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 12, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
3,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 13, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
4,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 14, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
5,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 15, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
6,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 16, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
7,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 17, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
8,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 18, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
9,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 19, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
1,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 20, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
1,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 21, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
1,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 22, NULL),
NULL,
NULL));

INSERT INTO point VALUES(
1,
'point',
MDSYS.SDO_GEOMETRY(
2001,
NULL,
MDSYS.SDO_POINT_TYPE(14, 23, NULL),
NULL,
NULL));
-----------------------------------------------------------------
-- UPDATE METADATA VIEW --
-----------------------------------------------------------------
-- Update the USER_SDO_GEOM_METADATA view. This is required
-- before the Spatial index can be created.

INSERT INTO USER_SDO_GEOM_METADATA
VALUES (
'point',
'shape',
MDSYS.SDO_DIM_ARRAY( -- 15X15 grid, virtually zero tolerance
MDSYS.SDO_DIM_ELEMENT('X', 0, 15, 0.005),
MDSYS.SDO_DIM_ELEMENT('Y', 0, 15, 0.005)
),
NULL -- SRID
);

-----------------------------------------------------------------
-- CREATE THE SPATIAL INDEX --
-----------------------------------------------------------------

CREATE INDEX point_idx
ON point(shape)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;