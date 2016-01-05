spool C:\dp_zayo.txt create
SET HEADING OFF FEEDBACK OFF ECHO OFF PAGESIZE 0
set linesize 250

--Get datafiles and tablespace names:

select ('create tablespace ' || tablespace_name || ' datafile ''' || file_name || ''' SIZE 100M AUTOEXTEND ON NEXT 51200K MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL UNIFORM SIZE 320K LOGGING ONLINE SEGMENT SPACE MANAGEMENT MANUAL;') as expr from dba_data_files;

spool C:\dp_zayo.txt append

--User name and default tablespace:

SET SERVEROUTPUT ON

CREATE OR REPLACE GLOBAL TEMPORARY TABLE sde_owners (owner CHAR(30)) on commit delete rows;

DECLARE
  CURSOR owners IS
    SELECT * FROM sde.instances;
  SQL_STMT VARCHAR2(200);
BEGIN
  DBMS_OUTPUT.ENABLE (100000);
  FOR owner IN owners
  LOOP
    SQL_STMT := ('INSERT INTO SDE_OWNERS (OWNER) SELECT DISTINCT username
FROM dba_users    
WHERE username IN      
(SELECT owner FROM ' || owner.instance_name || '.table_registry)');
    EXECUTE IMMEDIATE SQL_STMT;
  END LOOP;
END;
/

select ('create user ' || username || ' identified by ' || lower(username)|| ' default tablespace ' ||  default_tablespace ||';') from dba_users where username in (select RTRIM(owner) from sde_owners);

select ('grant CREATE SESSION ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE TABLE ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE TRIGGER ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE SEQUENCE ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE PROCEDURE ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;

select ('grant EXECUTE ON DBMS_CRYPTO ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE INDEXTYPE ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE LIBRARY ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE OPERATOR ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE PUBLIC SYNONYM ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE TYPE ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE VIEW ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant DROP PUBLIC SYNONYM ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant ADMINISTER DATABASE TRIGGER ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;

select ('grant ALTER ANY INDEX ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant ALTER ANY TABLE ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE ANY INDEX ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE ANY TRIGGER ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE ANY VIEW ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant DROP ANY INDEX ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant DROP ANY VIEW ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant SELECT ANY TABLE ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;

select ('grant ALTER SESSION ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant ANALYZE ANY ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant SELECT ANY DICTIONARY ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE DATABASE LINK ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant CREATE MATERIALIZED VIEW ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant RESTRICTED SESSION ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant UNLIMITED TABLESPACE ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant ALTER SYSTEM ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;
select ('grant SELECT_CATALOG_ROLE ' || RTRIM(OWNER) || ';') AS GRANTS from sde_owners;

commit;

spool out;

