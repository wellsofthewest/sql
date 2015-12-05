set echo off;
set heading off;
set pagesize 0;
set linesize 500;
set feedback off
spool \\gisdb\gis\ADMIN\SDEcommands\SDE_Analyze_Run.bat;
select 'sdetable -o rebuild_index -x ALL -i sde:oracle10g -u sde -p sysman@gisdata -N -t ' || table_name from tabs order by table_name;
select 'sdetable -o update_dbms_stats -n ALL -m COMPUTE -i sde:oracle10g -u sde -p sysman@gisdata -N -t ' || table_name from tabs order by table_name;
select 'sdetable -o rebuild_index -x ALL -i sde:oracle10g -u gis_admin -p sysman@gisdata -N -t ' || table_name from table_registry where owner='GIS_ADMIN' order by table_name;
select 'sdetable -o update_dbms_stats -n ALL -m COMPUTE -i sde:oracle10g -u gis_admin -p sysman@gisdata -N -t ' || table_name from table_registry where owner='GIS_ADMIN' order by table_name;
spool off;
exit;