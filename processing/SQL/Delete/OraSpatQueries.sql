SET LINESIZE 130
SET PAGESIZE 50000
SET ECHO OFF
set VERIFY OFF

COL RESULT FOR A60

-- Obtains Oracle Spatial Query results
-- @OraSpatQueries
-- Shawn Thorne
-- ArcSDE - Developer Support Group 
-- ESRI Inc.
-- Created : 6/30/2005
-- Last Modified : 1/11/2006 Added the MBR query to check for both 2-D 
-- and 3-D data


-- specify the location where you want the script results written to

spool C:\TEMP\OraSpatQueries_Results.txt Replace



PROMPT
PROMPT
PROMPT
PROMPT *********************************************************************************;
PROMPT THIS SCRIPT WILL RUN NUMEROUS QUERIES AGAINST ANY ORACLE SPATIAL LAYER YOU SELECT
PROMPT *********************************************************************************;
PROMPT
PROMPT
PROMPT
PROMPT

show user;

select table_name from user_sdo_geom_metadata order by table_name;

-- select sdo_table_name from mdsys.sdo_geom_metadata_table where -- --
-- sdo_owner = '&user';

PROMPT
PROMPT

ACCEPT layer char PROMPT 'Choose an Oracle Spatial layer from the list above : ';

PROMPT
PROMPT

describe &layer;

PROMPT
PROMPT
ACCEPT geom char PROMPT  'Enter in the Geometry Column for the layer "&layer" : ';
PROMPT
PROMPT
ACCEPT oid PROMPT  'Enter in the Object ID Column for the layer "&layer" : ';

PROMPT
PROMPT
PROMPT MBR Extent for "&layer"
PROMPT ================================
PROMPT For 3-D Data 
PROMPT ============
select sdo_aggr_mbr(&geom) from (&layer);

PROMPT
PROMPT
PROMPT For 2-D Data
PROMPT ============
select sdo_tune.extent_of(upper('&layer'),upper('&geom')) from dual;


PROMPT
PROMPT
PROMPT Metadata for "&layer"
PROMPT ==============================
select * from user_sdo_geom_metadata where table_name = upper('&layer');

PROMPT
PROMPT
PROMPT Validation for "&layer"
PROMPT ================================
select a.&oid, sdo_geom.validate_geometry_with_context (a.&geom,(select diminfo from user_sdo_geom_metadata where table_name = upper('&layer') and column_name = upper('&geom'))) RESULT from &layer a;

PROMPT Another way to Validate the Layer
PROMPT =================================

select &oid, sdo_geom.validate_geometry_with_context(&geom, .005) result from &layer;

PROMPT
PROMPT
PROMPT SRID for "&layer"
PROMPT ==========================
select unique a.&geom..sdo_srid from &layer a;

PROMPT
PROMPT
PROMPT GTYPE for "&layer"
PROMPT ===========================
select unique a.&geom..sdo_gtype from &layer a;

PROMPT
PROMPT
PROMPT Ensure features have correct SRID and GTYPE in "&layer"
PROMPT ================================================================
select a.&geom from &layer a where rownum < 4;

PROMPT
PROMPT
PROMPT Types of features found in the "&layer" shape column
PROMPT =============================================================
set serveroutput on

exec sdo_tune.mix_info(upper('&layer'),upper('&geom'));
PROMPT
PROMPT
PROMPT

-- PROMPT Get vertices for "&layer"
-- PROMPT ==================================
-- select c.&oid, t.x, t.y from &layer c, table(sdo_util.getvertices(c.&geom)) t;
PROMPT
PROMPT

PROMPT
PROMPT ===========================
PROMPT This script has completed!!
PROMPT ===========================
PROMPT

spool off

set VERIFY ON
set ECHO ON

$ notepad C:\TEMP\OraSpatQueries_Results.txt




