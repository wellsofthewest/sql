CREATE TABLE sde.invalid_geometries
  (
    owner NVARCHAR2(32),
    table_name NVARCHAR2(160),
    spatial_column NVARCHAR2(32),
    rowid_column NVARCHAR2(32),
    geom_error VARCHAR2(4000)
  )


SET SERVEROUTPUT ON 
DECLARE CURSOR geom_check IS
SELECT DISTINCT l.owner,
  l.table_name,
  l.spatial_column,
  t.rowid_column
FROM sde.layers l,
  sde.table_registry t
WHERE l.table_name = t.table_name
AND l.table_name  IN
  (SELECT TABLE_NAME FROM all_tab_columns WHERE data_type = 'SDO_GEOMETRY'
  )
AND l.table_name IN
  (SELECT object_name FROM all_objects WHERE object_type = 'TABLE'
  )
ORDER BY l.owner,
  l.table_name;
sql_stmt VARCHAR2(2000);

BEGIN
  DBMS_OUTPUT.ENABLE (100000000);
  FOR fc IN geom_check
  LOOP
    sql_stmt := ('select sdo_geom.validate_geometry_with_context(f.' || fc.spatial_column || ', 0.005) as geom_validate, f.' || fc.spatial_column || ' from ' || fc.owner || '.' || fc.table_name || ' f WHERE sdo_geom.validate_geometry_with_context(f.' || fc.spatial_column || ', 0.005) <> ''TRUE'';');
    --('insert into invalid_geometries (owner, table_name, spatial_column, rowid_column, geom_error) values (' || fc.owner || ',' || fc.table_name || ',' || fc.spatial_column || ',' || fc.rowid_column || ',' || '(select sdo_geom.validate_geometry_with_context(f.' || fc.spatial_column || ', 0.005) as geom_validate, f.' || fc.spatial_column || ' from ' || fc.owner || '.' || fc.table_name || ' f WHERE sdo_geom.validate_geometry_with_context(f.' || fc.spatial_column || ', 0.005) <> ''TRUE''));');
    DBMS_OUTPUT.PUT_LINE(SQL_STMT);
    COMMIT;
  END LOOP;
END;
/

UPDATE user_sdo_geom_metadata
SET diminfo =
  (SELECT MDSYS.SDO_DIM_ARRAY( MDSYS.SDO_DIM_ELEMENT('X', minx, maxx, 0.0005), MDSYS.SDO_DIM_ELEMENT('Y', miny, maxy, 0.0005)) AS diminfo
  FROM
    (SELECT TRUNC( MIN( v.x ) - 1,0) AS minx,
      ROUND( MAX( v.x )       + 1,0) AS maxx,
      TRUNC( MIN( v.y )       - 1,0) AS miny,
      ROUND( MAX( v.y )       + 1,0) AS maxy
    FROM
      (SELECT SDO_AGGR_MBR(a.shape) AS mbr FROM <TABLENAME> a
      ) b,
      TABLE(mdsys.sdo_util.getvertices(b.mbr)) v
    )
  )
WHERE table_name = '<TABLENAME>'
AND column_name  = '<SPATIALCOLUMN>';



UPDATE user_sdo_geom_metadata SET SRID=2926




INSERT
INTO user_sdo_geom_metadata
  VALUES
  (
    'CONS_PRES_REGULATR_BU',
    'GDO_GEOMETRY_ORIG',
    (SELECT MDSYS.SDO_DIM_ARRAY( MDSYS.SDO_DIM_ELEMENT('X', minx, maxx, 0.0005), MDSYS.SDO_DIM_ELEMENT('Y', miny, maxy, 0.0005)) AS diminfo
  FROM
    (SELECT TRUNC( MIN( v.x ) - 1,0) AS minx,
      ROUND( MAX( v.x )       + 1,0) AS maxx,
      TRUNC( MIN( v.y )       - 1,0) AS miny,
      ROUND( MAX( v.y )       + 1,0) AS maxy
    FROM
      (SELECT SDO_AGGR_MBR(a.shape) AS mbr FROM <TABLENAME> a
      ) b,
      TABLE(mdsys.sdo_util.getvertices(b.mbr)) v
    )
  ),
    2227 -- SRID
  );

select distinct w.shape.sdo_srid from dpr.dogoffleash w;

select * from user_sdo_geom_metadata where table_name LIKE 'DOGOFFLEASH';

update dpr.dogoffleash a
   set a.shape = sdo_util.rectify_geometry(a.shape, 0.005)
   
   
select sdo_geom.validate_geometry_with_context(f.SHAPE, 0.005) as geom_validate, f.SHAPE from DPR.DOGOFFLEASH f WHERE sdo_geom.validate_geometry_with_context(f.SHAPE, 0.005) <> 'TRUE';

SELECT * FROM DBA_IND_COLUMNS WHERE TABLE_NAME='DOGOFFLEASH';

DROP INDEX DPR.A59914_IX1