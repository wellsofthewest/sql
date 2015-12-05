SET ECHO OFF
SET VERIFY OFF

-- Deletes an Oracle Spatial layer
-- @delete_layer
-- Shawn Thorne
-- ArcSDE - Developer Support Group 
-- ESRI Inc.
-- Created : 9/2/2005

show user

PROMPT
PROMPT

set pagesize 50000

PROMPT
PROMPT
PROMPT
PROMPT *****************************************************************************************;
PROMPT THIS SCRIPT ENSURES THAT AN ORACLE SPATIAL LAYER HAS BEEN COMPLETELY REMOVED
PROMPT *****************************************************************************************;

PROMPT
PROMPT

SHOW USER;
PROMPT
PROMPT

select table_name from user_sdo_geom_metadata order by table_name;

PROMPT
PROMPT

ACCEPT layer char PROMPT 'Enter name of layer to be dropped : ';

PROMPT
PROMPT

drop table &layer;

drop view &layer;

PROMPT

delete from user_sdo_geom_metadata where table_name = upper('&layer');

PROMPT

select index_name, table_name from user_indexes where table_name = upper('&layer');

PROMPT

commit;

PROMPT
PROMPT
PROMPT
PROMPT Layer '&layer' has been successfully deleted 
PROMPT
PROMPT
PROMPT ****************************
PROMPT This script has completed!!!
PROMPT ****************************
PROMPT
SET VERIFY ON