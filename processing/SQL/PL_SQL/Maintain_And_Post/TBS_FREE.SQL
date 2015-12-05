
SET ECHO OFF
SET VERIFY OFF


COL "Tablespace" FORMAT A20
COL "Used MB"    FORMAT 99,999,999
COL "Free MB"    FORMAT 99,999,999
COL "Total MB"   FORMAT 99,999,999 

SELECT
   fs.tablespace_name              "Tablespace",
   (df.totalspace - fs.freespace)  "Used MB",
   fs.freespace                    "Free MB",
   df.totalspace                   "Total MB",
   round(100 * (fs.freespace / df.totalspace)) "% Free"
FROM (select tablespace_name, round(sum(bytes) / 1048576) TotalSpace
     from dba_data_files group by tablespace_name) df,
     (select tablespace_name, round(sum(bytes) / 1048576) FreeSpace
     from dba_free_space group by tablespace_name) fs
WHERE df.tablespace_name = fs.tablespace_name
ORDER BY 1; 


PROMPT
PROMPT
PROMPT


-- specify the datafiles for each tablespace


