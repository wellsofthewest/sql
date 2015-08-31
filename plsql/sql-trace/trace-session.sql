
/***********************************************************************
*
*N  trace-session.SQL  --  Oracle DBMS Trace
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This script serves to start tracing all events in a single
*   session. NOTE: This will not trace events that occur outside
*   the SQL session (ex. ArcMap)
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
*   DBMS: Oracle
*   DBMS Version: 11.2.0
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*T  Tags:
*   10046, Trace, Oracle 
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*R  Resources:
*   http://docs.oracle.com/cd/E25054_01/server.1111/e16638/sqltrace.htm
*E
***********************************************************************/

--GENERAL SESSION TRACING

--Flush buffer cache and shared pool
ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;

--Trace file location
show parameter user_dump_dest

--Session wide tracing 
alter session set events '10046 trace name context forever,level 12';
alter session set tracefile_identifier = '{TracefileName}';

--Disabled Session wide tracing
alter session set events '10046 trace name context off';
