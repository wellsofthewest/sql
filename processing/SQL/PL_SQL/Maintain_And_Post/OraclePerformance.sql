SET SERVEROUTPUT ON

DECLARE

    CURSOR Owner_Cur IS
        SELECT DISTINCT(OWNER) owner
	FROM sde.table_registry 
	ORDER BY owner;

    CURSOR Index_Cur IS
        SELECT owner, index_name 
        FROM dba_indexes 
        WHERE owner IN
         	(SELECT DISTINCT(owner) 
 		 FROM sde.table_registry) 
        AND INDEX_TYPE = 'NORMAL' 
        ORDER BY owner, index_name;

    SQL_STMT VARCHAR2(200);

BEGIN

    DBMS_OUTPUT.ENABLE (100000);

    FOR IndexRec IN Index_Cur LOOP
        SQL_STMT := ('ALTER INDEX ' || IndexRec.owner || '.' || IndexRec.index_name || ' REBUILD');
	DBMS_OUTPUT.PUT_LINE(SQL_STMT);
        EXECUTE IMMEDIATE SQL_STMT;
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;

    FOR OwnerRec IN Owner_Cur LOOP
        DBMS_OUTPUT.PUT_LINE('Analyzing schema : ' || OwnerRec.owner);
        DBMS_STATS.GATHER_SCHEMA_STATS(OwnerRec.owner);
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;

END;

/