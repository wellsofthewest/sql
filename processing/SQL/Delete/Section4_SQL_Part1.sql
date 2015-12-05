Valid Geometries:
POINT (1 1)
LINESTRING (0 0, 1 1)
POLYGON ((0 0, 3 3, 3 0, 0 0 ))

Validation rules for point shapes
-The area and length of points are 0.0.

Validation rules for linestrings
-Sequential duplicate points are deleted.
-Each part must have at least two distinct points.
-Parts may touch each other at the end points.
-Lines can intersect themselves.

Validation rules and operations for area shapes
-Duplicate sequential occurrences of a coordinate point are deleted.
-Dangles are deleted.
-Line segments are verified to be closed (z-coordinates at start and end points must also be the same) and don't cross.
-For area shapes with holes, holes must reside wholly inside the outer boundary. ArcGIS eliminates any holes that are outside the outer boundary.
-A hole that touches an outer boundary at a single common point is converted into an inversion of the area shape.
-Multiple holes that touch at common points are combined into a single hole.
-Multipart area shapes cannot overlap. However, two parts may touch at a point.
-Multipart area shapes cannot share a common boundary. Common boundaries are dissolved.
-If two rings have a common boundary, they are merged into one ring.

FAQ:  When are ArcSDE features validated?
http://support.esri.com/en/knowledgebase/techarticles/detail/27330

Geometry validation
http://resources.arcgis.com/en/heLP/MAIN/10.2/index.html#//006z00000028000000


Create MSSQL geometry objects
select geometry::STGeomFromText('point (1 4)',0);
select geometry::STGeomFromText('linestring (0 0, 0 1)',0);
select geometry::STGeomFromText('polygon ((0 0, 0 1, 1 1, 1 0))',0);


Create MSSQL Geometry/Geography Tables

Geometry:
CREATE TABLE MSSQL_GEOM (OID INT NOT NULL, SHAPE GEOMETRY);
INSERT INTO MSSQL_GEOM (OID, SHAPE) VALUES (1, geometry::STGeomFromText('POLYGON ((0 0, 3 3, 3 0, 0 0))', 2227));
INSERT INTO MSSQL_GEOM (OID, SHAPE) VALUES (2, geometry::STGeomFromText('POLYGON ((0 0, -3 -3, -3 0, 0 0))', 2227));
INSERT INTO MSSQL_GEOM (OID, SHAPE) VALUES (3, geometry::STGeomFromText('POLYGON ((0 0, 3 -3, 3 0, 0 0))', 2227));
INSERT INTO MSSQL_GEOM (OID, SHAPE) VALUES (4, geometry::STGeomFromText('POLYGON ((0 0, -3 3, -3 0, 0 0))', 2227));

Geography:
CREATE TABLE MSSQL_GEOG (OID INT NOT NULL, SHAPE GEOGRAPHY);
INSERT INTO MSSQL_GEOG (OID, SHAPE) VALUES (1, geography::STGeomFromText('POLYGON ((0 0, 3 3, 3 0, 0 0))', 4326));
INSERT INTO MSSQL_GEOG (OID, SHAPE) VALUES (2, geography::STGeomFromText('POLYGON ((0 0, -3 -3, -3 0, 0 0))', 4326));
INSERT INTO MSSQL_GEOG (OID, SHAPE) VALUES (3, geography::STGeomFromText('POLYGON ((0 0, 3 -3, 3 0, 0 0))', 4326));
INSERT INTO MSSQL_GEOG (OID, SHAPE) VALUES (4, geography::STGeomFromText('POLYGON ((0 0, -3 3, -3 0, 0 0))', 4326));

Create MSSQL Geometry/Geography Indexes:
ALTER TABLE MSSQL_GEOM ADD  CONSTRAINT MSSQL_GEOM_PK PRIMARY KEY CLUSTERED 
(OID ASC);

CREATE SPATIAL INDEX MSSQL_GEOM_IDX ON MSSQL_GEOM(SHAPE)
USING  GEOMETRY_AUTO_GRID 
WITH (BOUNDING_BOX =(-10, -10, 10, 10), CELLS_PER_OBJECT = 16);

ALTER TABLE MSSQL_GEOG ADD  CONSTRAINT MSSQL_GEOG_PK PRIMARY KEY CLUSTERED 
(OID ASC);

CREATE SPATIAL INDEX MSSQL_GEOG_IDX ON MSSQL_GEOG(SHAPE)
USING  GEOMETRY_AUTO_GRID 
WITH (BOUNDING_BOX =(-10, -10, 10, 10), CELLS_PER_OBJECT = 16);


Query Spatial Table:
--Gather SRID
SELECT SHAPE.STSrid FROM MSSQL_GEOM;
SELECT SHAPE.STSrid FROM MSSQL_GEOG;

--Gather Well-Known Text:
SELECT SHAPE.STAsText() FROM MSSQL_GEOM;
SELECT SHAPE.STAsText() FROM MSSQL_GEOG;

--Gather Number of Points:
SELECT SHAPE.STNumPoints() FROM MSSQL_GEOM;
SELECT SHAPE.STNumPoints() FROM MSSQL_GEOG;

--Gather Area
SELECT SHAPE.STArea() FROM MSSQL_GEOM;
SELECT SHAPE.STArea() FROM MSSQL_GEOG;

--Gather Length
SELECT SHAPE.STLength() FROM MSSQL_GEOM;
SELECT SHAPE.STLength() FROM MSSQL_GEOG;