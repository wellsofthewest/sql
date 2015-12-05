
-----------------------------------------------------------
-- Script to gather information about an Oracle instance --
-----------------------------------------------------------
-- Shawn Thorne                                          --
-- Geodatabase Product Engineer                          --
-- ESRI Inc.                                             --  
-- Created : 10.4.2012                                   --
-- Updated : 4.2.2014									 --
-----------------------------------------------------------

clear screen

PROMPT
PROMPT

PROMPT *********************************************************
PROMPT * Script to gather information about an Oracle instance *
PROMPT *********************************************************
PROMPT
PROMPT

sho user

PROMPT
PROMPT

PROMPT This script needs to be executed as the SYS or SYSTEM user, or with a user that has been assigned the DBA role!!
PROMPT
PROMPT
PAUSE  Press CTRL+C to quit, or press any key to continue ...
PROMPT

CLEAR BREAKS COMPUTES COLUMNS

host mkdir C:\TEMP

spool C:\TEMP\ORA_Info_Results.txt replace

set linesize 130
set pages 500

col member for a80
col "Filesize in MBs" for 9,999,999.99

PROMPT
PROMPT
PROMPT


PROMPT *******************
PROMPT * ORACLE BIT INFO *
PROMPT *******************

select 
   length(addr)*4 || '-bit' "ORA Bit Version"
from
   v$process 
where
   ROWNUM =1;
   

PROMPT
PROMPT
PROMPT


PROMPT *****************************************
PROMPT * ARCHIVING, FLASHBACK, RECYCLEBIN INFO *
PROMPT *****************************************

select log_mode, flashback_on from v$database;

col value for a12
select name, value from v$parameter where name = 'recyclebin';


-- Disable Archiving
-- shutdown immediate;
-- startup mount
-- alter database noarchivelog;
-- alter database open;


-- Disable Flashback Recovery
-- alter database flashback off;


-- Disable Recyclebin
-- alter system set recyclebin=off scope=spfile;
-- shutdown immediate
-- startup open
-- create pfile from spfile;  

 
PROMPT
PROMPT
PROMPT
 
PROMPT ***********************************
PROMPT * SID, ORA VERSION, HOSTNAME INFO *   
PROMPT ***********************************   
   
select instance_name,version "ORA VERSION",substr(host_name,1,30) "HOST NAME",active_state "STATE",archiver "ARCHIVE" from v$instance;
   
   
PROMPT
PROMPT
PROMPT


PROMPT ************************************
PROMPT * INSTALLED ORACLE COMPONENTS INFO *
PROMPT ************************************


SELECT substr(comp_name,1,40) AS "ORACLE COMPONENT", substr(schema,1,30) AS "SCHEMA", substr(version,1,12) AS version 
FROM dba_registry
ORDER BY 1;

PROMPT
PROMPT
PROMPT


PROMPT *******************
PROMPT * TABLESPACE INFO *
PROMPT *******************

COL c1 heading "Tablespace Name" FORMAT A20
COL c2 heading "Used MB"    	 FORMAT 99,999,999
COL c3 heading "Free MB"    	 FORMAT 99,999,999
COL c4 heading "Total MB"   	 FORMAT 99,999,999 

break on report

compute sum of c2 on report
compute sum of c3 on report
compute sum of c4 on report

SELECT
   fs.tablespace_name              c1,
   (df.totalspace - fs.freespace)  c2,
   fs.freespace                    c3,
   df.totalspace                   c4,
   round(100 * (fs.freespace / df.totalspace)) "% Free"
FROM (select tablespace_name, round(sum(bytes) / 1048576) TotalSpace
     from dba_data_files group by tablespace_name) df,
     (select tablespace_name, round(sum(bytes) / 1048576) FreeSpace
     from dba_free_space group by tablespace_name) fs
WHERE df.tablespace_name = fs.tablespace_name
ORDER BY 1; 

PROMPT
PROMPT
PROMPT

PROMPT ****************************
PROMPT * TABLESPACE METADATA INFO *
PROMPT ****************************

set long 9999999

select dbms_metadata.get_ddl('TABLESPACE',tbsp.tablespace_name) from dba_tablespaces tbsp;

PROMPT
PROMPT
PROMPT


PROMPT *****************
PROMPT * REDO LOG INFO *
PROMPT *****************

col FILENAME      for a60
col "Size in MBs" for 999,999,999.99

select l.group#,lf.member "FILENAME",l.status,lf.type,l.bytes/1024/1024 "Size in MBs" from v$log l, v$logfile lf where l.group#=lf.group# order by 2;


PROMPT
PROMPT
PROMPT
 
 PROMPT **********************
 PROMPT * CONTROL FILES INFO *
 PROMPT **********************
 SELECT substr(name,1,80) FILENAME FROM V$CONTROLFILE order by 1;

 PROMPT
 PROMPT
 PROMPT
 
 PROMPT ******************
 PROMPT * TEMP FILE INFO *
 PROMPT ******************
 SELECT substr(name,1,80) FILENAME, bytes/1024/1024 "Filesize in MBs" FROM V$TEMPFILE order by 1;

 PROMPT
 PROMPT
 PROMPT 

PROMPT **********************
PROMPT * USER METADATA INFO *
PROMPT **********************
PROMPT
PROMPT

select dbms_metadata.get_ddl('USER',usr.username) from dba_users usr;

PROMPT
PROMPT
PROMPT All users in the database
PROMPT =========================
select username,substr(default_tablespace,1,30) default_tablespace, substr(temporary_tablespace,1,20) temporary_tablespace, substr(profile,1,20) profile, substr(account_status,1,20) account_status from dba_users order by 1;


PROMPT
PROMPT
PROMPT Users that have data in SDE
PROMPT ===========================
PROMPT
PROMPT SDE Layers
PROMPT -----------

select owner,count(*) from sde.layers group by owner order by 1;

PROMPT
PROMPT SDE Tables
PROMPT -----------

select owner,count(*) from sde.table_registry group by owner order by 1;

PROMPT
PROMPT ST_Geometry Layers
PROMPT -------------------

select owner,count(*) from sde.st_geometry_columns group by owner order by 1;


PROMPT ********************
PROMPT * SDE VERSION INFO *
PROMPT ********************

PROMPT

select major,minor,bugfix,description  from sde.version;
 

PROMPT
PROMPT
PROMPT

PROMPT ************************
PROMPT * USER PRIVILEGES INFO *
PROMPT ************************

PROMPT
PROMPT Privileges assigned to users that have data in ArcSDE
PROMPT =====================================================

break on "USERNAME" skip 1

select grantee "USERNAME", granted_role "PRIVILEGES ASSIGNED"
from dba_role_privs
where grantee in (select distinct owner from sde.table_registry
                  union
                  select distinct owner from sde.st_geometry_columns
                  union
                  select distinct owner from sde.layers)
union
select grantee "USERNAME", privilege "PRIVILEGES ASSIGNED"
from dba_sys_privs
where grantee in (select distinct owner from sde.table_registry
                  union
                  select distinct owner from sde.st_geometry_columns
                  union
                  select distinct owner from sde.layers)
order by 1;


PROMPT
PROMPT
PROMPT


PROMPT ******************************
PROMPT * WHOs CONNECTED TO SDE INFO *
PROMPT ******************************


col username format a22
col program  format a20
col machine  format a20

select substr(username,1,12) "USERNAME", sid, serial#, program, substr(machine,1,20) machine, logon_time from v$session where schemaname in (select distinct owner from sde.table_registry) or schemaname in (select distinct owner from sde.st_geometry_columns) order by 1,2;

PROMPT
PROMPT
PROMPT

PROMPT ****************
PROMPT * PROFILE INFO *
PROMPT ****************

break on profile skip 1

select profile,resource_name, resource_type, limit from dba_profiles order by 1,2;

PROMPT
PROMPT
PROMPT

PROMPT ************
PROMPT * SGA INFO *
PROMPT ************

select * from v$sgainfo order by name;

PROMPT
PROMPT
PROMPT


PROMPT ************
PROMPT * PGA INFO *
PROMPT ************

column name  format a50
column value format 999,999,999,999,999

select
   name, 
   value 
from
   v$pgastat 
order by 1;


PROMPT
PROMPT
PROMPT

PROMPT *********************************
PROMPT * INITIALIZATION PARAMETER INFO *
PROMPT *********************************

sho parameters

PROMPT
PROMPT
PROMPT

/*
PROMPT ***********************************************************************
PROMPT * HIDDEN PARAMETER INFO (11GR2) - Run as SYS user or user with SYSDBA *
PROMPT ***********************************************************************

set pages 2000
set lines 130
col "Parameter"      for a45 word wrapped
col "Description"    for a40 word wrapped
col "Session Value"  for a20 word wrapped
col "Instance Value" for a20 word wrapped


SELECT a.ksppinm "Parameter", a.ksppdesc "Description", b.ksppstvl "Session Value", c.ksppstvl "Instance Value"
FROM x$ksppi a, x$ksppcv b, x$ksppsv c
WHERE a.indx = b.indx
AND a.indx = c.indx
AND a.ksppinm LIKE '/_%' escape '/'
ORDER BY 1
/

PROMPT
PROMPT
PROMPT
 
 */
 
spool off

host notepad C:\TEMP\ORA_Info_Results.txt




