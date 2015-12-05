
set echo off
set verify off
set feedback off

PROMPT
PROMPT
ACCEPT uname char PROMPT 'Enter in the name of the user you want to create : ';
PROMPT
PROMPT
ACCEPT psswd char PROMPT 'Enter in a password for &uname : ';
PROMPT
PROMPT

select tablespace_name TABLESPACES from dba_tablespaces where tablespace_name not in ('SYSTEM','SYSAUX','TEMP') and tablespace_name not like 'UNDO%' order by 1;

PROMPT
PROMPT
ACCEPT dtbsp char PROMPT 'Enter in the default tablespace for &uname : ';
PROMPT
PROMPT

create user &uname identified by &psswd default tablespace &dtbsp temporary tablespace temp account unlock;

grant connect, resource, create view, unlimited tablespace to &uname;
commit;

PROMPT
PROMPT
PROMPT User &uname created!!
PROMPT
PROMPT

-- drop user &uname cascade;

set verify on
set feedback on