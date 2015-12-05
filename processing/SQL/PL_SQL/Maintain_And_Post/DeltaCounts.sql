SET SERVEROUTPUT ON

DECLARE
  CURSOR fcList
  IS
    SELECT items.name AS FC_Name,
      XMLCast(XMLQuery('*/Versioned' PASSING xmltype(items.definition) RETURNING CONTENT) AS VARCHAR(100)) AS Versioned
    FROM sde.gdb_items_vw items
    INNER JOIN sde.gdb_itemtypes itemtypes
    ON items.Type         = itemtypes.UUID
    WHERE itemtypes.Name IN ('Feature Class', 'Table');
  sql_stmt VARCHAR2(200);
  adds     VARCHAR2(61);
  dels     VARCHAR2(61);
  aCNT     NUMBER;
  dCNT     NUMBER;
BEGIN
  DBMS_OUTPUT.ENABLE (100000000);
  FOR fc IN fcList
  LOOP
    IF fc.versioned = 'true' THEN
      SELECT (t.owner
        || '.A'
        || t.registration_id)
      INTO adds
      FROM table_registry t
      WHERE (t.owner
        || '.'
        || t.table_name) = upper(fc.fc_name);
      SELECT (t.owner
        || '.D'
        || t.registration_id)
      INTO dels
      FROM table_registry t
      WHERE (t.owner
        || '.'
        || T.TABLE_NAME) = UPPER(FC.FC_NAME);
      SQL_STMT          := 'select count(*) from ' || ADDS || '';
      EXECUTE IMMEDIATE SQL_STMT INTO ACNT;
      SQL_STMT := 'select count(*) from ' || DELS || '';
      EXECUTE IMMEDIATE SQL_STMT INTO DCNT;
      DBMS_OUTPUT.PUT_LINE(rpad(upper(fc.fc_name),64,'.') || '(ADDS)' || rpad(acnt,10) || ' (DELS)' || rpad(dcnt,10));
    END IF;
  END LOOP;
END;
/