-- Obtains information for Oracle tracing and trace files.
-- @active_sessions.txt
-- Tom B. 
-- ESRI Inc.
-- January 19, 2006


-- Run as SYS

PROMPT
PROMPT
ACCEPT uSYS char PROMPT 'Specify the SYS password : ' HIDE;
PROMPT
PROMPT
ACCEPT uSID char PROMPT 'Specify the EZCONNECT syntax or the Net Service Name : ';
PROMPT


conn sys/&&uSYS@&&uSID as sysdba

PROMPT
PROMPT

grant select on v_$process to public;
grant select on v_$session to public;
grant select on v_$instance to public;
grant select on v_$parameter to public;

create or replace view active_view as
select b.username, b.sid, b.serial#, b.program, to_char(b.logon_time, 'MON-DD-YYYY HH24:MI:SS') LOGON, 
       c.instance_name || '_ora_' || ltrim(to_char(a.spid)) ||'.trc' tracefile, d.value, b.terminal
  from v$process a, v$session b, v$instance c, v$parameter d
 where a.addr = b.paddr
   and b.username not in ('SYS','SYSTEM','DBSNMP','SYSMAN')
   and d.name = 'user_dump_dest'
/

create or replace public synonym active_sessions for active_view;

grant select on active_sessions to public;

-- Run as SDE

create or replace view active_users as select username, sid, serial#, terminal, program, logon, tracefile from active_sessions;




-- Current session

create or replace view trace_file as
SELECT lower(c.value || '\' || d.instance_name || '_ora_' || to_char(a.spid) || '.trc') "FILE_NAME", b.username
FROM v$process a, v$session b, v$parameter c, v$instance d
WHERE a.addr = b.paddr
AND b.audsid = userenv('sessionid')
AND c.name = 'user_dump_dest';

-- create public synonym trace_file for trace_file_view;
grant select on trace_file to public; 



-- Enables & Disables a Trace Session
-- @trace_session.sql
-- Shawn Thorne
-- ArcSDE - Developer Support Group 
-- ESRI Inc.
-- Created : 3/24/2006

SET LINESIZE 140
SET PAGESIZE 50000
SET ECHO OFF
SET FEEDBACK OFF

clear screen

PROMPT
PROMPT
PROMPT
PROMPT ****************************************************;
PROMPT THIS SCRIPT WILL ENABLE AND DISABLE A TRACE SESSION
PROMPT ****************************************************;
PROMPT
PROMPT
PROMPT


PROMPT
PROMPT
PROMPT

show user;

PROMPT
PROMPT
select * from active_sessions;

PROMPT
ACCEPT userSID char PROMPT 'Specify the SID for the user you want to trace : ';
PROMPT
PROMPT

PROMPT
ACCEPT userSERIAL char PROMPT 'Specify the SERIAL# for the user you want to trace : ';
PROMPT
PROMPT

PROMPT
ACCEPT tracetype char PROMPT 'Specify the type of Oracle Trace you want to perform : ';
PROMPT
PROMPT

PROMPT
ACCEPT tracelevel char PROMPT 'Specify the Trace Level for this "&tracetype" Trace : ';
PROMPT
PROMPT

alter system set timed_statistics = TRUE;

-- Behind the scenes, this package set a 10046 event at level 1 
-- (captures just sql).
-- exec sys.dbms_system.set_sql_trace_in_session(&&userSID,&&userSERIAL,TRUE);

-- Enables the trace session
exec sys.dbms_system.set_ev(&&userSID,&&userSERIAL,&&tracetype,&&tracelevel,'');

PROMPT
PROMPT


PROMPT ***********************************************
PROMPT WARNING!!!  A Trace Session has been enabled!!
PROMPT ***********************************************
PROMPT
PROMPT

pause  "Press Enter when you want to stop this Trace Session"
PROMPT


-- Disables the trace session
-- exec sys.dbms_system.set_sql_trace_in_session(&&userSID,&&userSERIAL,FALSE);
-- alter system set timed_statistics = FALSE;

exec sys.dbms_system.set_ev(&&userSID,&&userSERIAL,&&tracetype,0,'');

-- clear screen

PROMPT
PROMPT **************************************
PROMPT The Trace Session has been disabled!!
PROMPT **************************************
PROMPT


SET FEEDBACK ON




