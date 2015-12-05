
set long 9999999
set lines 130
set longc 9999999

col username for a12
col program format a20
col message for a40
col sid for 99999
col serial# for 9999999
col machine for a20
set sql_text for a999

break on username skip 1

select username,process,program,sid,serial#,machine from v$session order by 1,2,3,4;


PROMPT
PROMPT

ACCEPT sid char PROMPT 'Enter in the SID for the desired Username : ';

PROMPT
PROMPT

PROMPT ===============================================
PROMPT == The SQL Syntax that is currently running. ==
PROMPT ===============================================
PROMPT  

select /*+ ORDERED USE_NL(st) */ sql_text
  from v$session ses,
       v$sqltext st
  where st.address = ses.sql_address
   and st.hash_value=ses.sql_hash_value
   and ses.sid=&&sid
order by piece;


PROMPT
PROMPT

PROMPT =================================================================================
PROMPT == Time remaining until this Long Runnning Transaction completes (in seconds). ==
PROMPT =================================================================================
PROMPT  

select username,sid,serial#,message,totalwork,time_remaining,sql_id from v$session_longops where sid = &&sid;


PROMPT
PROMPT ================================================================
PROMPT ==  To see the SQL_TEXT for any previous SQL_ID's execute :   ==
PROMPT ==                                                            ==
PROMPT ==  select sql_text from v$sqltext where sql_id = '<SQL_ID>'  ==
PROMPT ==  order by sql_text DESC;                                   ==
PROMPT ================================================================
PROMPT
PROMPT
