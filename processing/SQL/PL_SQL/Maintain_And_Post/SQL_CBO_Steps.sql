--Large Bounding Box FULL TABLE

ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;

SELECT /* FULL(SDE.ANSCHLUESSE) */ MAX(old_id)
FROM sde.anschluesse
WHERE sde.st_envintersects(shape, 3343000, 5661000, 3500000, 5863000) = 1;

SELECT sql_id, sql_text FROM v$sql WHERE sql_text LIKE '%MAX(old_id)%';
--Use SQL ID to display the explain plan and the trace in the next two steps

SELECT *
FROM TABLE(dbms_xplan.display_cursor('6axrwpfkdtzkp', 0, 'iostats last'));


EXEC dbms_sqldiag.dump_trace(p_sql_id => '6axrwpfkdtzkp', p_child_number => 0, p_component => 'Compiler', p_file_id=> 'cbo_unvers_lbb')


--Small Bounding Box

ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;

select MAX(old_id) 
from anschluesse
where sde.st_envintersects(shape, 3441000, 5744000, 3442000, 5745000) = 1;

SELECT sql_id, sql_text FROM v$sql WHERE sql_text LIKE '%MAX(old_id)%';
--Use SQL ID to display the explain plan and the trace in the next two steps

SELECT *
FROM TABLE(dbms_xplan.display_cursor('73xq8qpz6c61g', 0, 'iostats last'));

exec dbms_sqldiag.dump_trace(p_sql_id => '73xq8qpz6c61g', p_child_number => 0, p_component => 'Compiler', p_file_id=> 'cbo_unvers_sbb')


--Large Bounding Box FULL TABLE

ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;

SELECT /*+ FULL(a) */ MAX(old_id)
FROM sde.anschluesse a
WHERE sde.st_envintersects(shape, 3343000, 5661000, 3500000, 5863000) = 1;

SELECT sql_id, sql_text FROM v$sql WHERE sql_text LIKE '%MAX(old_id)%';
--Use SQL ID to display the explain plan and the trace in the next two steps

SELECT *
FROM TABLE(dbms_xplan.display_cursor('8ffav7qrkx9ph', 0, 'iostats last'));


EXEC dbms_sqldiag.dump_trace(p_sql_id => '8ffav7qrkx9ph', p_child_number => 0, p_component => 'Compiler', p_file_id=> 'cbo_unvers_lbb_full')

