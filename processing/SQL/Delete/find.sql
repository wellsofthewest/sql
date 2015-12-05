SET ECHO OFF
SET VERIFY OFF

BREAK ON owner SKIP 1 ON table_type SKIP 1
COLUMN owner FORMAT A15
COLUMN table_type FORMAT A11
COLUMN table_name FORMAT A51

PROMPT

ACCEPT chrSearch CHAR PROMPT 'Enter in a search string : '

PROMPT

SELECT
	owner,table_type,table_name
FROM
	all_catalog
WHERE
	LOWER(table_name) LIKE LOWER('%&chrSearch%')
ORDER BY
	1,2,3
/


SET VERIFY ON
