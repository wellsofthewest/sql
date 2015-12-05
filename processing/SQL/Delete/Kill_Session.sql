
-- clear screen

----------------------------------------
-- Script to kill a session in Oracle --
----------------------------------------
-- Shawn Thorne                       --
-- Geodatabase Product Engineer       --
-- ESRI Inc.                          --  
-- March 3rd, 2013                    --
----------------------------------------

col schemaname for a25
col program    for a25
col machine    for a25

--set verify off
--set feedback off

set lines 130
set pages 100

break on schemaname skip 2

PROMPT
PROMPT
PROMPT
PROMPT
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT * This script will kill an active session in Oracle. * 
PROMPT ******************************************************
PROMPT
PROMPT

sho user

PROMPT
PROMPT

PROMPT This script needs to be executed as the SYS or SYSTEM user, or as a user that has been assigned the DBA role!!
PROMPT
PROMPT
PAUSE  Press CTRL+C to quit, or press any key to continue ...
PROMPT

-- clear break


PROMPT

select schemaname,sid,serial#,program,machine from v$session where schemaname <> 'SYS' order by 1;

PROMPT
PROMPT

ACCEPT usid char PROMPT " Enter in the SID value for the User you want to kill the session of : ";

PROMPT
PROMPT

ACCEPT userial char PROMPT " Enter in the SERIAL# for the User you want to kill the session of : ";

PROMPT
PROMPT

ALTER SYSTEM KILL SESSION '&&usid,&&userial' IMMEDIATE;

PROMPT
PROMPT

PROMPT Waiting 5 seconds for the session to be removed.
exec dbms_lock.sleep(5);

PROMPT
PROMPT

select schemaname,sid,serial#,program,machine from v$session where schemaname <> 'SYS' order by 1;

PROMPT
PROMPT

PROMPT " The specified Session has been terminated!!"

PROMPT
PROMPT



