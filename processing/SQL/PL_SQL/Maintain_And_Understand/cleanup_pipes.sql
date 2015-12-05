set serveroutput on

DECLARE
 CURSOR pipe_list IS 
  SELECT name FROM v$db_pipes;

pipe_result NUMBER;

BEGIN
  dbms_output.put_line('Cleaning up old pipes in instance');
  
  FOR del_pipes IN pipe_list LOOP
   
    pipe_result := DBMS_PIPE.REMOVE_PIPE(del_pipes.name);

  END LOOP;

END;
/
