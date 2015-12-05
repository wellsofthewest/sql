SELECT a.tablespace_name,
  a.file_name,
  a.bytes allocated_bytes,
  b.free_bytes
FROM dba_data_files a,
  (SELECT file_id, SUM(bytes) free_bytes FROM dba_free_space b GROUP BY file_id
  ) b
WHERE a.file_id=b.file_id
ORDER BY a.tablespace_name;


ALTER DATABASE datafile 'C:\DATA\ORACLE11203\PRODUCT\11.2.0\DBHOME_1\DATABASE\SDE_TBS' resize 1000M;
  
ALTER TABLESPACE SDE_TBS ADD DATAFILE 'C:\DATA\ORACLE11203\PRODUCT\11.2.0\DBHOME_1\DATABASE\SDE_TBS_01.DBF' SIZE 100M AUTOEXTEND ON NEXT 400M MAXSIZE unlimited;

COMMIT;