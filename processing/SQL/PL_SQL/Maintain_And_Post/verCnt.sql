SET serveroutput ON

SET linesize 200

spool DeltaCount.txt append

SELECT to_char(SYSDATE, 'DD-MON-YY HH24:MI:SS') AS "Delta Count Check Time" FROM dual;

DECLARE
  CURSOR VERLIST
  IS
    SELECT V.NAME,
      V.OWNER,
      V.STATE_ID,
      V.CREATION_TIME,
      S.CLOSING_TIME
    FROM VERSIONS V
    JOIN STATES S
    ON V.STATE_ID = S.STATE_ID;
  ADDS NUMBER(30);
  DELS NUMBER(30);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Version                                                          Adds     Deletes      Last Mod    ');
  dbms_output.put_line('================================================================ ======== ======== ==================');
  FOR VER IN VERLIST
  LOOP
    SELECT COUNT(*)
    INTO adds
    FROM A132
    WHERE SDE_STATE_ID IN
      (SELECT STATE_ID
      FROM STATES
      WHERE LINEAGE_NAME IN
        (SELECT LINEAGE_NAME
        FROM STATES
        WHERE STATE_ID =
          (SELECT STATE_ID FROM VERSIONS WHERE NAME = VER.NAME
          )
        )
      );
    SELECT COUNT(*)
    INTO DELS
    FROM D132
    WHERE SDE_STATE_ID IN
      (SELECT STATE_ID
      FROM STATES
      WHERE LINEAGE_NAME IN
        (SELECT LINEAGE_NAME
        FROM STATES
        WHERE STATE_ID =
          (SELECT STATE_ID FROM VERSIONS WHERE NAME = VER.NAME
          )
        )
      );
    DBMS_OUTPUT.PUT_LINE(rpad(VER.NAME,64,'.') || ' ' || lpad(adds,8,' ') || ' ' || lpad(dels,8,' ') || ' ' || 
	to_char(ver.closing_time, 'DD-MON-YY HH24:MI:SS'));
  END LOOP;
END;
/

spool OFF

host notepad DeltaCount.txt