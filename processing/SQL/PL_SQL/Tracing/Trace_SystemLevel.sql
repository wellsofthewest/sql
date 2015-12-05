/*
=========================
Oracle Tracing Procedures 
=========================
*/

--GENERAL INSTANCE TRACING

--Flush buffer cache and shared pool
ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;

--Trace file location
show parameter diagnostic_dest

--Instance wide tracing 
alter system set events '10046 trace name context forever,level 12';

--Disabled Instance wide tracing
alter system set events '10046 trace name context off';

--Find Trace file for a single user or process
select u_dump.value || '\' || instance.value || '_ora_' || v$process.spid
|| nvl2(v$process.traceid, '_' || v$process.traceid, null ) || '.trc' "Trace File"
from V$PARAMETER u_dump
cross join V$PARAMETER instance
cross join V$PROCESS
join V$SESSION on v$process.addr = V$SESSION.paddr
where u_dump.name = 'user_dump_dest'
and instance.name = 'instance_name' and v$session.username = 'SDE';


http://docs.oracle.com/cd/E25054_01/server.1111/e16638/sqltrace.htm#i4206