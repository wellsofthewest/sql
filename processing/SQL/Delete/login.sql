DEFINE _editor=notepad

SET ARRAYSIZE		100
--SET DESCRIBE		DEPTH ALL INDENT ON
SET FEEDBACK		0
SET ECHO		OFF
SET LINESIZE 		130
SET PAGESIZE		100
SET PAUSE		'Press any key to continue...'
SET SERVEROUTPUT	ON SIZE UNLIMITED

col username 	 for a22
col privilege 	 for a30
col granted_role for a20
col role         for a20
col table_name 	 for a30

-- Temporary for script
SET FEEDBACK OFF

DECLARE

	vchGlobalName	VARCHAR2(255);

BEGIN

	SELECT
		global_name
	INTO
		vchGlobalName
	FROM
		global_name;

	DBMS_OUTPUT.PUT_LINE( 'You are connected to : ' || vchGlobalName );
	DBMS_OUTPUT.PUT_LINE( CHR(13) );

END;
/


alter session set nls_date_format = 'Dy DD-Mon-YYYY HH24:MI:SS';

SET sqlprompt "&&_USER@&&_CONNECT_IDENTIFIER SQL>"

-- Turn back on after script
SET FEEDBACK 1
