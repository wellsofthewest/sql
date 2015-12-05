SET ECHO OFF -- Don't display commands as they are executed
SET FEEDBACK OFF -- Don't display the number of records returned 
SET VERIFY OFF -- Don't display the command
SET HEADING OFF -- Don't print column headings

-- Shawn Thorne
-- ESRI Inc.
-- 4/8/2008
-- This script will generate the DB Verify commands for every Data File

 
spool C:\temp\dbv_syntax.sql replace;

SELECT '$ dbv file='||file_name||' blocksize=8192' from dba_data_files ORDER BY file_name;

spool off;


-- $ write c:\temp\dbv_syntax.sql

@C:\temp\dbv_syntax.sql


PROMPT
PROMPT
PROMPT ***************************
PROMPT This script has completed!!
PROMPT ***************************
PROMPT
PROMPT
PROMPT

PAUSE 'Press Enter to close ...'

EXIT 