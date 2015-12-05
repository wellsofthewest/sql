CREATE TABLE cola_markets
  (
    mkt_id NUMBER PRIMARY KEY,
    name   VARCHAR2(32),
    shape MDSYS.SDO_GEOMETRY
  );
INSERT
INTO cola_markets VALUES
  (
    1,
    'cola_a',
    MDSYS.SDO_GEOMETRY( 2003,                        -- 2-dimensional polygon
    NULL, NULL, MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,3), -- one rectangle (1003 = exterior)
    MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,7)               -- only 2 points needed to
    -- define rectangle (lower left and upper right) with
    -- Cartesian-coordinate data
    )
  );
INSERT
INTO cola_markets VALUES
  (
    2,
    'cola_b',
    MDSYS.SDO_GEOMETRY( 2003,                        -- 2-dimensional polygon
    NULL, NULL, MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,1), -- one polygon (exterior polygon ring)
    MDSYS.SDO_ORDINATE_ARRAY(5,1, 8,1, 8,6, 5,7, 5,1) )
  );
INSERT
INTO cola_markets VALUES
  (
    3,
    'cola_c',
    MDSYS.SDO_GEOMETRY( 2003,                        -- 2-dimensional polygon
    NULL, NULL, MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,1), -- one polygon (exterior polygon ring)
    MDSYS.SDO_ORDINATE_ARRAY(3,3, 6,3, 6,5, 4,5, 3,3) )
  );
INSERT
INTO cola_markets VALUES
  (
    4,
    'cola_d',
    MDSYS.SDO_GEOMETRY( 2003,                        -- 2-dimensional polygon
    NULL, NULL, MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,4), -- one circle
    MDSYS.SDO_ORDINATE_ARRAY(8,7, 10,9, 8,11) )
  );
INSERT
INTO USER_SDO_GEOM_METADATA VALUES
  (
    'cola_markets',
    'shape',
    MDSYS.SDO_DIM_ARRAY( -- 20X20 grid
    MDSYS.SDO_DIM_ELEMENT('X', 0, 20, 0.005), MDSYS.SDO_DIM_ELEMENT('Y', 0, 20, 0.005) ),
    NULL -- SRID
  );
CREATE INDEX cola_spatial_idx ON cola_markets
  (
    shape
  )
  INDEXTYPE IS MDSYS.SPATIAL_INDEX;
  
  commit;
  