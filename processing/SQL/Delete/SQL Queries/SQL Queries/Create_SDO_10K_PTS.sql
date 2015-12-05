----------------------------------------------------------------------
-- Script Name:  Create_SDO_10K_PTS.SQL
--      
-- Purpose    :  Create an SDO_GEOMETRY POINT FC with 10,000 Features
--
-- Author     :  Shawn Thorne
--               ESRI Inc.
--
-- Created    :  3.13.2014
----------------------------------------------------------------------


-- Create a SDO_GEOMETRY (POINT) Feature Class

-- drop table sdo_pt_fc purge;
 
CREATE TABLE SDO_PT_FC (
id NUMBER(38) NOT NULL,
name VARCHAR2(32),
SHAPE MDSYS.SDO_GEOMETRY);


-- Insert 10000 records

set serveroutput on size unlimited

declare

x    integer(4);
Y    integer(4);
i    integer(38);
stmt varchar2(255);

BEGIN

i := 0;

 For x in 1..20 loop
  For y in 1..20 loop
   i := i + 1;
   stmt := ('INSERT INTO SDO_PT_FC VALUES('||i||', ''PT_'||i||''', MDSYS.SDO_GEOMETRY(2001,4269,MDSYS.SDO_POINT_TYPE('||x||','||y||', NULL),NULL,NULL))');
   --dbms_output.put_line(stmt);
   execute immediate(stmt); 
  end loop;
 end loop;

END;
/


-- Create Metadata
INSERT INTO USER_SDO_GEOM_METADATA
VALUES (
'SDO_PT_FC',
'SHAPE',
MDSYS.SDO_DIM_ARRAY( 
MDSYS.SDO_DIM_ELEMENT('X', -179, 179, 0.005),
MDSYS.SDO_DIM_ELEMENT('Y', -89, 89, 0.005)
),
4269 -- SRID (reserved for future Spatial releases)
);




-- Create Spatial Index
CREATE INDEX SDO_PT_FC_INDX ON SDO_PT_FC(SHAPE) INDEXTYPE IS MDSYS.SPATIAL_INDEX;


COMMIT;



