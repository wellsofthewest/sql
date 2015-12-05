


PROMPT
PROMPT

sho parameter cdb

PROMPT
PROMPT
PROMPT
PROMPT ----------------- PDBS -----------------


-- select name, open_mode from v$pdbs;

select name, con_id, open_mode from v$containers;

-- After Startup up the CDB, you need to open the PDB's

alter pluggable database all open;

column pdb_id format 999
column pdb_name format a12
column file_id format 9999
column tablespace_name format a15
column file_name format a60

BREAK ON PDB_NAME SKIP 2

PROMPT
PROMPT 
PROMPT ----------------- DATA FILES -----------------

SELECT p.pdb_name, p.pdb_id, d.file_id, d.tablespace_name, d.file_name
FROM cdb_pdbs p, cdb_data_files d
WHERE p.pdb_id = d.con_id
ORDER BY p.pdb_id;


BREAK ON TABLESPACE_NAME SKIP 1

PROMPT
PROMPT
PROMPT ----------------- TEMP FILES -----------------

SELECT tablespace_name, con_id, file_id, file_name
FROM cdb_temp_files
ORDER BY con_id;


PROMPT
PROMPT
PROMPT ------------------ PDB HISTORY ------------------

column db_name format a10
column con_id format 999
column pdb_name format a15
column operation format a16
column op_timestamp format a28
column cloned_from_pdb_name format a15

SELECT db_name, con_id, pdb_name, operation, op_timestamp, cloned_from_pdb_name
FROM cdb_pdb_history
WHERE con_id > 2
ORDER BY con_id;


PROMPT
PROMPT
PROMPT ----------------- PDB STATUS -----------------

column name format a15
column restricted format a10
column open_time format a30

SELECT name, open_mode, restricted, open_time FROM v$pdbs;


PROMPT
PROMPT

select * from cdb_pdbs;








