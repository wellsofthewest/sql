/*
================================
Oracle System Tracing Procedures 
================================
*/

--GENERAL INSTANCE TRACING

--Flush buffer cache and shared pool
ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;

--Trace file location
show parameter user_dump_dest

--Instance wide tracing 
alter system set events '10046 trace name context forever,level 12';

--Disabled Instance wide tracing
alter system set events '10046 trace name context off';

--Find Trace file for a single user or process
select u_dump.value || '\'  || instance.value || '_ora_' || v$process.spid
|| nvl2(v$process.traceid, '_' || v$process.traceid, null ) || '.trc' "Trace File"
from V$PARAMETER u_dump
cross join V$PARAMETER instance
cross join V$PROCESS
join V$SESSION on v$process.addr = V$SESSION.paddr
where u_dump.name = 'user_dump_dest'
and instance.name = 'instance_name' and v$session.username = 'SDE';


http://docs.oracle.com/cd/E25054_01/server.1111/e16638/sqltrace.htm#i4206




/*
=================================
Oracle Session Tracing Procedures 
=================================
*/

--GENERAL SESSION TRACING

--Flush buffer cache and shared pool
ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;

--Trace file location
show parameter user_dump_dest

--Session wide tracing 
alter session set events '10046 trace name context forever,level 12';
alter session set tracefile_identifier = 'CLT_Trace';

--Disabled Session wide tracing
alter session set events '10046 trace name context off';



/*
==================================
Oracle ORADEBUG Tracing Procedures 
==================================
*/

--Must be run as SYSDBA

--Format query columns
COLUMN USERNAME FORMAT A15
COLUMN PROGRAM FORMAT A20

--Select ORAPID value for the required user
SELECT P.PID "ORAPID", S.USERNAME, S.PROGRAM
FROM V$PROCESS P JOIN V$SESSION S 
ON P.ADDR = S.PADDR
WHERE S.USERNAME = 'SDE';

--Flush buffer cache and shared pool
ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;

--Set ORAPID in ORADEBUG to the PID from V$PROCESS
ORADEBUG SETORAPID <PID>

--Set the tracefile name
ORADEBUG SETTRACEFILEID <TRACEFILE_NAME>

--Start the trace
ORADEBUG EVENT 10046 TRACE NAME CONTEXT FOREVER, LEVEL 12

--Verify the trace file name and location
ORADEBUG TRACEFILE_NAME

--Stop the trace
ORADEBUG EVENT 10046 TRACE NAME CONTEXT OFF 
--ORADEBUG CLOSE_TRACE is a viable alternative



/*
=====================================
Oracle DBMS_SYSTEM Tracing Procedures 
=====================================
*/

--Must be run as SYSDBA

--Format query columns
COLUMN USERNAME FORMAT A15
COLUMN PROGRAM FORMAT A20

--Select SID and SERIAL# value for the required user
SELECT S.SID, S.SERIAL#, S.USERNAME, S.PROGRAM
FROM V$PROCESS P JOIN V$SESSION S 
ON P.ADDR = S.PADDR
WHERE S.USERNAME = 'SDE';

--Flush buffer cache and shared pool
ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;

--Start the session trace for a different user
exec dbms_support.start_trace_in_session(<SID>,<SERIAL#>,waits=>true,binds=>false);

--Stop the session trace
exec dbms_support.stop_trace_in_session(<SID>,<SERIAL#>);


--Find Trace file for a single user or process
select u_dump.value || '\' || instance.value || '_ora_' || v$process.spid
|| nvl2(v$process.traceid, '_' || v$process.traceid, null ) || '.trc' "Trace File"
from V$PARAMETER u_dump
cross join V$PARAMETER instance
cross join V$PROCESS
join V$SESSION on v$process.addr = V$SESSION.paddr
where u_dump.name = 'user_dump_dest'
and instance.name = 'instance_name' and v$session.username = 'SDE';


--Requires the install of the $ORACLE_HOME/rdbms/admin/dbmssupp.sql script


/*
===================================
Oracle TKPROF Formatting Procedures 
===================================
*/


--Create a TKPROF formatted trace file
TKPROF <INPUT> <OUTPUT>

--Create a TKPROF formatted trace file SQL file of non-recursive statements
TKPROF <INPUT> <OUTPUT> RECORD=<SQLFILE>

--Create a TKPROF formatted trace file with a DDL/DML for statistics
TKPROF <INPUT> <OUTPUT> INSERT=<SQLFILE>clear

--Create a TKPROF formatted trace file with sorted queries
TKPROF <INPUT> <OUTPUT> SORTS=(EXEELA, FCHELA, PRSELA)







