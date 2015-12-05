/***********************************************************************
*
*N  LogonTrigger.SQL  --  Oracle DBMS Trace
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This script serves as a series of steps to complete the import
*	data pump process using the IMPDP utility. This script is meant to
*	be run one step at a time.
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*H  History:
*
*    Christian Wells        07/01/2015               Original coding.
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*V  Versions Supported:
*   EGDB: All
*	DBMS: Oracle
*	DBMS Version: All
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*T  Tags:
*   10046, Trace, Oracle, Logon, Trigger   
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*R  Resources:
*   Using Triggers:	
*	https://docs.oracle.com/database/121/TDDDG/tdddg_triggers.htm#TDDDG50000
*E
***********************************************************************/


--Create Trigger for user

CREATE TRIGGER "SYS"."SDE_LOGON" AFTER
LOGON ON DATABASE begin
if user like 'SDE%' then
  execute immediate 'alter session set tracefile_identifier = ''on_logon_SDE''';
  execute immediate 'alter session set timed_statistics=true';
  execute immediate 'alter session set max_dump_file_size=unlimited';
  execute immediate 'alter session set events ''10046 trace name context forever, level 12''';
end if;
end;
/


--Drop Trigger for user

drop trigger sde_logon;


/*

NOTES: 
-If the session is not ended, the trace will continue running even if the trigger is dropped

*/
