

set SERVEROUTPUT ON

DECLARE

CURSOR all_keysets IS
SELECT owner, table_name
FROM all_tables
WHERE table_name LIKE 'KEYSET_%';

sess_id INTEGER;
valid_sess INTEGER;
lock_name VARCHAR2(30);
lock_handle VARCHAR2(128);
lock_status INTEGER;
cnt INTEGER DEFAULT 0;

BEGIN

FOR drop_keysets IN all_keysets LOOP

sess_id := TO_NUMBER(SUBSTR(drop_keysets.table_name, 8));

SELECT COUNT(*) INTO valid_sess FROM sde.process_information WHERE owner = drop_keysets.owner AND sde_id = sess_id;

IF valid_sess = 1 THEN

lock_name := 'SDE_Connection_ID#' || TO_CHAR (sess_id);
DBMS_LOCK.ALLOCATE_UNIQUE (lock_name,lock_handle);
lock_status := DBMS_LOCK.REQUEST (lock_handle,DBMS_LOCK.X_MODE,0,TRUE);

IF lock_status = 0 THEN

DELETE FROM sde.process_information WHERE sde_id = sess_id;
DELETE FROM sde.state_locks WHERE sde_id = sess_id;
DELETE FROM sde.table_locks WHERE sde_id = sess_id;
DELETE FROM sde.object_locks WHERE sde_id = sess_id;
DELETE FROM sde.layer_locks WHERE sde_id = sess_id;
dbms_output.put_line('Removed orphaned process_information entry ('||sess_id||')');

EXECUTE IMMEDIATE 'DROP TABLE '||drop_keysets.owner||'.'||drop_keysets.table_name;
cnt := cnt + 1;

END IF;

ELSE

EXECUTE IMMEDIATE 'DROP TABLE '||drop_keysets.owner||'.'||drop_keysets.table_name;
cnt := cnt + 1;

END IF;

END LOOP;

dbms_output.put_line('Dropped '||cnt||' keyset tables.');

END;
/ 