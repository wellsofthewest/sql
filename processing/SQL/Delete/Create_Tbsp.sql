

set echo off
set verify off
set feedback off

set lines 130
col file_name for a70
col tablespace_name for a20

select tablespace_name, file_name from dba_data_files order by 1,2;

PROMPT
PROMPT
ACCEPT tbsp char PROMPT 'Enter in the name of the tablespace you want to create : '
PROMPT
PROMPT
ACCEPT tbspath char PROMPT 'Enter in the path and file name for the tablespace "&tbsp" : '
PROMPT
PROMPT
ACCEPT filesize char PROMPT 'Enter in the file size for the tablespace "&tbsp" (in MBs) : '
PROMPT
PROMPT
ACCEPT extendsize char PROMPT 'Enter in the size you want the tablespace "&tbsp" to autoextend by (in MBs) : '
PROMPT
PROMPT



CREATE TABLESPACE &tbsp 
    NOLOGGING 
    DATAFILE '&tbspath' SIZE 
    &filesize AUTOEXTEND 
    ON NEXT  &extendsize MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL UNIFORM
    SIZE 128K SEGMENT SPACE MANAGEMENT  AUTO;

commit;

PROMPT
PROMPT
PROMPT Tablespace &tbsp has been created!!
PROMPT
PROMPT

-- @Delete_Tbsp.sql

set verify on
set feedback on

