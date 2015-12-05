/*
=========================================
Enable Flashback and Create Restore Point
=========================================
*/

-- Shutdown the Oracle Instance
shutdown immediate


-- Startup the Oracle Instance in mount mode
startup mount

-- Set ArchiveLog mode ON
alter database archivelog;

-- Set Flashback Recovery Size
alter system set db_recovery_file_dest_size=10G;

-- Set Flashback Retention Target
alter system set db_flashback_retention_target=4320;

-- Set Flashback Recovery Destination
alter system set db_recovery_file_dest='D:\flashback';

-- Set Flashback ON
alter database flashback on;


-- Open Database
alter database open;


-- Confirm Flashback Variables are set
select flashback_on, log_mode from v$database;

-- Create the Restore Point
create restore point restortPoint;



/*
===========================
Flashback to Restore Point
===========================
*/

-- Shutdown the Oracle Instance
shutdown immediate;

--Change directory to the DBHOME
cd C:\app\oracle\product\11.2.0\dbhome

--Set Oracle SID
set ORACLE_SID=<SID>

-- Startup the Oracle Instance in mount mode
startup mount

-- Flashback to the Restore Point
flashback database to restore point sde;

-- Open Database and reset logs
alter database open resetlogs;



/*
===========================
Find all Restore Points
===========================
*/

SELECT NAME, SCN, TIME, DATABASE_INCARNATION#, GUARANTEE_FLASHBACK_DATABASE,STORAGE_SIZE
FROM V$RESTORE_POINT;


/*
===========================
Drop Restore Points
===========================
*/

DROP RESTORE POINT sde;