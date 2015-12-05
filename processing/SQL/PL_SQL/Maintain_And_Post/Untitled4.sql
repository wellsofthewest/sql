INSERT
INTO USER_SDO_GEOM_METADATA VALUES
  (
    'dimension_test',                   --SDO TABLE NAME
    'gdo_geometry_orig',              --SDO GEOMETRY COLUMN
    (SELECT MDSYS.SDO_DIM_ARRAY     --SDO DIM INFO ARRAY CALCULATION
        (
         MDSYS.SDO_DIM_ELEMENT('X', MINX, MAXX, 0.0005) 
        ,MDSYS.SDO_DIM_ELEMENT('Y', MINY, MAXY, 0.0005)
        --,MDSYS.SDO_DIM_ELEMENT('Z', MINZ, MAXZ, 0.0005) --OPTIONAL DIM ELEMENT FOR Z VALUES
        --,MDSYS.SDO_DIM_ELEMENT('M', MINM, MAXM, 0.0005) --OPTIONAL DIM ELEMENT FOR M VALUES
        ) AS DIMINFO
    FROM
      (SELECT 
         TRUNC( MIN( V.X )       - 1,0) AS MINX
        ,ROUND( MAX( V.X )       + 1,0) AS MAXX
        ,TRUNC( MIN( V.Y )       - 1,0) AS MINY
        ,ROUND( MAX( V.Y )       + 1,0) AS MAXY
        --,TRUNC( MIN( V.Y )       - 1,0) AS MINZ         --MIN Z VALUE CALCULATION
        --,ROUND( MAX( V.Y )       + 1,0) AS MAXZ         --MAX Z VALUE CALCULATION
        --,TRUNC( MIN( V.Y )       - 1,0) AS MINM         --MIN M VALUE CALCULATION
        --,ROUND( MAX( V.Y )       + 1,0) AS MAXM         --MAX M VALUE CALCULATION
      FROM
        (SELECT SDO_AGGR_MBR(A.gdo_geometry_orig) AS MBR 
          FROM dimension_test A
        ) B,
        TABLE(MDSYS.SDO_UTIL.GETVERTICES(B.MBR)) V
      )
    ),
    2227                             --SRID
  );
  
  
  
desc sjpw.dimension;

select sdo_geom.sdo_buffer(a.gdo_geometry_orig, 0.0003, 1) from sjpw.dimension a;

create table sjpw.aaa_test as
SELECT SDO_GEOM.SDO_BUFFER(A.GDO_GEOMETRY_ORIG, 0.0003, 1) AS SHAPE, 
DIMENSION_ID FROM SJPW.DIMENSION A
where dimension_id < 100;

truncate table sjpw.aaa_test;

INSERT INTO SJPW.AAA_TEST (SHAPE, DIMENSION_ID)
SELECT A.GDO_GEOMETRY_ORIG AS SHAPE, 
DIMENSION_ID FROM SJPW.DIMENSION A
where dimension_id < 100;

select dimension_id from sjpw.dimension;


  CREATE INDEX "SJPW"."SHAPE_90633_1_SIDX" ON "SJPW"."AAA_TEST"
    (
      "SHAPE"
    )
    INDEXTYPE IS "MDSYS"."SPATIAL_INDEX" PARAMETERS ('SDO_COMMIT_INTERVAL = 1000 ');
    
    
create table sjpw.dimension_test as select gdo_geometry_orig from sjpw.dimension;