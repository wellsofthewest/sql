Complex Queries by Christian Wells (Esri Geodata PSS Support) and Easy Queries/Notes/Comments by Matthew Ziebarth (Esri Geodata PSS Support) 2015

####--VERSIONING TAB--####

#-Metadata Subtab-#

//This tab involves two queries. The first query returns useful metadata about each version. The second query returns a current version coun.//t

--Version Metadata
SELECT V.NAME,
      V.OWNER AS VERSION_OWNER,
      V.STATE_ID,
      S.LINEAGE_NAME AS LINEAGE_ID,
      V.PARENT_NAME AS PARENT_VERSION,
      V.CREATION_TIME AS CREATE_DATE,
      S.CLOSING_TIME AS LAST_MODIFIED
    FROM sde_VERSIONS V
    JOIN sde_STATES S
    ON V.STATE_ID = S.STATE_ID;

--Version Count
SELECT COUNT(*) FROM sde_VERSIONS;



#-Deltas per Feature Class per Version Subtab-#

//This tab shows which version and which feature class is responsible for a certain volume of edits. This is similar to what is currently running for the on-site project, except that current query is hard-coded to a specific set of delta tables. We will be supplying a query that will allow a drop-down menu to be utilized to select either a feature class or a version and have returned the number of adds/deletes per version for a specific feature class or adds/deletes per feature class for a specific version, respectively. This is the most complex component of the project at this time. This is almost complete.//

--Drop-down of versions
SELECT NAME FROM sde_VERSIONS;

--Drop-down of feature classes/tables
SELECT ITEMS.NAME AS FC_NAME, T.REGISTRATION_ID
FROM gdb_items items
INNER JOIN sde.gdb_itemtypes itemtypes
ON ITEMS.TYPE = ITEMTYPES.UUID
JOIN sde_TABLE_REGISTRY T
on upper(items.PhysicalName) = upper(t.database_name + '.' + t.owner + '.' + t.table_name)
WHERE ITEMTYPES.NAME  IN ('Feature Class', 'Table')
AND Definition.value('(/DEFeatureClassInfo/Versioned)[1]', 'varchar(20)') = 'true'
ORDER BY 1

--Delta counts by feature class and version
    SELECT 'Updated Features' as delta, COUNT(*) as cnt
    FROM A{0}
    WHERE SDE_STATE_ID IN
      (SELECT STATE_ID
      FROM sde_STATES
      WHERE LINEAGE_NAME IN
        (SELECT LINEAGE_NAME
        FROM sde_STATES
        WHERE STATE_ID =
          (SELECT STATE_ID FROM sde_VERSIONS WHERE NAME = '{1}'
          )
        )
      )
    UNION
    SELECT 'Deleted Features' as delta, COUNT(*) as cnt
    FROM D{0}
    WHERE SDE_STATE_ID IN
      (SELECT STATE_ID
      FROM sde_STATES
      WHERE LINEAGE_NAME IN
        (SELECT LINEAGE_NAME
        FROM sde_STATES
        WHERE STATE_ID =
          (SELECT STATE_ID FROM sde_VERSIONS WHERE NAME = '{1}'
          )
        )
      )

--Delata counts by feature class only (ALL Versions)
SELECT 'Updated Features' as delta, COUNT(*) as cnt
    FROM A{0}
    UNION
    SELECT 'Deleted Features' AS DELTA, COUNT(*) AS CNT
    FROM D{0}

####--USERS TAB--####

#-Advanced Connection Subtab-#

//This tab will show enough information to identify how many users are connected, what application they are connected with, how long they have been connected, what machine they are connected on, as well as enough information to create an Oracle in-session trace. The SDE_ID can also be used for additional troubleshooting for orphaned connections, logfiles, keyset tables, etc.//

//Working on this query for SQL Server

#-Locks Per User Subtab-#

//This tab will show how many locks each user is currently responsible for, in addition to which locks table the lock exists in, what type of lock it is (SHARED or EXCLUSIVE), and when the lock occurred. This refers to the 4 ArcSDE locks tables: STATE_LOCKS, TABLE_LOCKS, LAYER_LOCKS, and OBJECT_LOCKS. This should quickly identify the machine responsible for the lock, or in a virtual environment the Operating System login responsible for the lock.//

--Every Lock ordered by SDE_ID
SELECT
  sde_PROCESS_INFORMATION.SDE_ID,
  OWNER,
  NODENAME,
  LOCKS.LOCK_TYPE,
  LOCKS.LOCK_TBL
FROM sde_PROCESS_INFORMATION,
  ( SELECT SDE_ID, LOCK_TYPE, 'LAYER' AS LOCK_TBL FROM SDE_layer_locks
  UNION ALL
  SELECT SDE_ID, LOCK_TYPE, 'OBJECT' AS LOCK_TBL FROM sde_OBJECT_LOCKS
  UNION ALL
  SELECT SDE_ID, LOCK_TYPE, 'STATE' AS LOCK_TBL FROM sde_STATE_LOCKS
  UNION ALL
  SELECT SDE_ID,
    LOCK_TYPE,
    'TABLE' AS LOCK_TBL
  FROM sde_TABLE_LOCKS
  ) LOCKS
WHERE sde_PROCESS_INFORMATION.SDE_ID = LOCKS.SDE_ID
ORDER BY sde_PROCESS_INFORMATION.SDE_ID;

--Lock Count per SDE_ID
SELECT SDE_ID, COUNT(SDE_ID) AS LOCK_COUNT FROM
( SELECT SDE_ID, LOCK_TYPE, 'LAYER' AS LOCK_TBL FROM SDE_layer_locks
  UNION ALL
  SELECT SDE_ID, LOCK_TYPE, 'OBJECT' AS LOCK_TBL FROM sde_OBJECT_LOCKS
  UNION ALL
  SELECT SDE_ID, LOCK_TYPE, 'STATE' AS LOCK_TBL FROM sde_STATE_LOCKS
  UNION ALL
  SELECT SDE_ID,
    LOCK_TYPE,
    'TABLE' AS LOCK_TBL
  FROM sde_TABLE_LOCKS
  ) as locks GROUP BY SDE_ID;


#-Log File Table Per User Subtab-#

//This tab will show all current logfiles in the geodatabase and whether or not they are in use by a current geodatabase connection (SDE_ID). This will also show if the log file has statistics built on the log table, which should be promptly removed. Finally, this will scan the log file dictionary tables (SDE_LOGFILES, SDE_LOGFILE_DATA, and SDE_LOGFILE_POOL) for any indication that a log file table is being reserved by a geodatabase connection that no longer exists. NOTE THAT ONLY SDE_LOGFILE_POOL IS CURRENTLY INCLUDED TO SCAN FOR ORPHANED POLL OF SESSION LOGS AND THIS TAB IS ONLY PROGRAMMED FOR SESSION BASED LOGS AT THIS TIME. If an orphaned row is returned from the log file dictionary table check, the row within that table should be cleared (not deleted) and the corresponding log file table should be truncated (not deleted). The following workflow can be used: EXEC DBMS_STATS.DELETE_TABLE_STATS('<SCHEMA>', 'SDE_LOGPOOL_<N>'); and then EXEC DBMS_STATS.LOCK_TABLE_STATS('<SCHEMA>', 'SDE_LOGPOOL_<N>'); //

--Session Log files list with statistics status
//No SQL Server Query for this

--Log file dictionary table orphan check for SDE_LOGFILE_POOL
//No SQL Server Query for this

#-Keyset Table Subtab-#

//This tab shows all keyset tables and whether or not they are orphaned or have statistics. They should not be orphaned or have statistics, and should be dropped from the database if orphaned and have statistics deleted and locked if statistics exist.//

--Keyset tables listed with statistics status
//No SQL Server Query for this

--Orphaned Keyset tables
//No SQL Server Query for this

####--DBMS TAB--####

#-Spatial Index Modified Subtab-#

//This tab shows the last time spatial indexes were rebuilt for each database object in the connected schema, including delta tables and tables not registered with the geodatabase that have (currently) either an SDO or an ST Spatial Index. This query is based on the last time the spatial index DDL was modified, which in ArcGIS is very likely when the index was either initially built or rebuilt.//

--SQL Server
SELECT object_name(object_id) as TABLE_NAME,
name as SPATIAL_INDEX_NAME,
STATS_DATE(OBJECT_ID, index_id) AS LAST_UPDATED
FROM sys.indexes
where TYPE = 4
order by 1,2;

//This tab shows the last time statistics were calculated for each table and feature class in the database in the connected schema, not just those registered with the geodatabase. This excludes the system tables of the ArcSDE, Workflow Manager, and Data Reviewer geodatabase.//

--SQL Server
SELECT object_name(object_id),
name,
STATS_DATE(OBJECT_ID, index_id) AS StatsUpdated
FROM sys.indexes
where upper(object_name(object_id)) in (select upper(table_name) from sde_table_registry)
order by 1,2;


#-Compress Log Subtab-#

//This tab gives a full view of the Compress Log.//
--SQL Server
SELECT * FROM sde_COMPRESS_LOG;

#-Replica Manager Subtab-#

//More functionality for this tab will come in a later release. For now, we can present any orphaned replicas.//

--SQL Server
--Orphaned replicas
select name from sde_versions where name not in (select v.name from gdb_items g join sde_versions v on g.objectid = Left(SubString(v.name, PatIndex('%[0-9.-]%', v.name), 10), PatIndex('%[^0-9.-]%', SubString(v.name, PatIndex('%[0-9.-]%', v.name), 10) + 'X')-1) where g.type = '{4ED4A58E-621F-4043-95ED-850FBA45FCBC}') and name like 'SYNC%';

#-Orphan Versions Subtab-#
--SQL Server
//This tab will return any orphaned versions, which would be versions that may exist in the versions table but have no connection to the rest of the geodatabase. This will check if the parent version exists as well as if the state_id the version points to exists.//

SELECT V.NAME FROM sde_VERSIONS V WHERE V.PARENT_NAME NOT IN   (SELECT V.NAME FROM sde_VERSIONS V) AND V.STATE_ID NOT IN  (SELECT S.STATE_ID FROM sde_STATES S);

#-Orphan Tables Subtab-#
--SQL Server
//This tab is a stack of query outputs that should always be empty and should cause an alert if any values are returned here. A more complete description of what each validation checks for will be added to the help later.//

SELECT table_name as LAYER_NOT_IN_TAB_REG FROM sde_layers  WHERE table_name not IN (SELECT table_name FROM sde_table_registry)
-- 2
SELECT table_name AS  LAYER_NOT_IN_COL_REG
FROM sde_layers
WHERE table_name not IN
	(SELECT table_name
	 FROM sde_column_registry);
-- 3
SELECT table_name LAYER_NOT_IN_GEOM_COL
FROM sde_layers
WHERE table_name not IN
	(SELECT f_table_name
	 FROM sde_geometry_columns);
-- 4
SELECT F_TABLE_NAME AS TABLE_NOT_IN_LAYERS
FROM sde_geometry_columns
WHERE f_table_name not IN
	(SELECT table_name
	 FROM sde_layers);
-- 5
SELECT TABLE_NAME AS LAYER_NOT_IN_GEOM_COL
FROM sde_layers
WHERE table_name not IN
	(SELECT f_table_name
	 FROM sde_geometry_columns);
-- 6
SELECT TABLE_NAME AS LAYER_SRID_NOT_IN_REF
FROM sde_layers
WHERE srid not IN
	(SELECT srid
	 FROM sde_spatial_references);
-- 7
SELECT TABLE_NAME AS LAYER_NOT_IN_T_REG
FROM sde_layers
WHERE table_name not IN
	(SELECT table_name
	 FROM sde_table_registry);
-- 8
SELECT TABLE_NAME AS LAYER_NOT_IN_DB
FROM sde_layers
WHERE table_name not IN
	(SELECT name
	 FROM sys.objects);
-- 9
SELECT F_TABLE_NAME AS BIN_TAB_NOT_IN_DB
FROM sde_geometry_columns
WHERE f_table_name not IN
	(SELECT name
	 FROM sys.objects);
-- 10
SELECT F_TABLE_NAME AS BIN_GEOM_NOT_IN_DB
FROM sde_geometry_columns
WHERE f_geometry_column not IN
	(SELECT name
	 FROM sys.columns);
-- 11
SELECT TABLE_NAME AS TABLE_NOT_IN_DB
FROM sde_table_registry
WHERE table_name not IN
	(SELECT name
	 FROM sys.objects);
-- 12
SELECT TABLE_NAME AS ORPHANED_KEYWORD
FROM sde_table_registry
WHERE config_keyword not IN
	(SELECT keyword
	 FROM dbtune);

#-Orphan Versioning Issues Subtab-#

//This tab includes the most common forms of versioning environment corruption such as any state tree issue. We may add queries to check if any of the sequences are out of order or out of sync in the future. Any results here should result in a call to Esri Support and to run the Diagnose Tables and Diagnose Metadata geoprocessing tools.//

--SQL Server
--Check for Incomplete or missing lineages:
select state_id AS MISSING_LINEAGE from sde_states ST where not exists (select * from sde_state_lineages SL where ST.lineage_name = SL.lineage_name and SL.lineage_id = 0);

--Check for Invalid parent state ids:
select state_id AS INVALID_PARENT_STATE from sde_states where parent_state_id not in
(select state_id from sde_states)
order by state_id;

--Check for States with no lineages:
select distinct state_id AS NOT_WITHIN_LINEAGE from sde_states where lineage_name not in (select lineage_name from sde_state_lineages) order by state_id;

--Check Lineages missing states:
select distinct state_id AS MISSING_STATE from sde_states where state_id not in (select lineage_id from sde_state_lineages) order by state_id;

--Check for edits with state_ids that have no parent:
Select state_id AS EDIT_WITHOUT_PARENT from sde_MVTABLES_MODIFIED where state_id in (select state_id from sde_states where parent_state_id not in (select state_id from sde_states));

####--SQL PANE--####

//This will be an open SQL pane that does not exhibit any error handling, meant to run select statements but not necessarily limited by anything other than database privileges. A warning should be added above or within this SQL pane that any queries sent from this window will directly interact with the database.//
