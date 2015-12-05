/***********************************************************************
*
*N  IMPDP.SQL  --  Import Data Pump Steps
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This script serves as a series of steps to complete the import
*	data pump process using the IMPDP utility. This script is meant to
*	be run one step at a time.
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*H  History:
*
*    Christian Wells        11/03/2014               Original coding.
*	 Matt Ziebarth			07/01/2015				 Add Index Functions
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*V  Versions Supported:
*   EGDB: All
*	DBMS: Oracle
*	DBMS Version: 11g and above 
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*T  Tags:
*   IMPDP, Data Pump, Oracle, Import   
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*R  Resources:
*   IMPDP Syntax:	
*	http://ss64.com/ora/impdp.html 
*E
***********************************************************************/


--1. Connect to an Oracle database as the Geodatabase Administrator

--2. Run the following query

SELECT A.OWNER  AS OWNER,
  B.TABLE_NAME  AS TABLE_NAME,
  A.COLUMN_NAME AS GEOMETRY_COL,
  CASE A.DATA_TYPE
    WHEN 'NUMBER'
    THEN 'SDELOB'
    ELSE A.DATA_TYPE
  END AS DATA_TYPE
FROM ALL_TAB_COLS A,
  SDE.LAYERS B
WHERE A.OWNER     = B.OWNER
AND a.TABLE_NAME  = b.TABLE_NAME
AND A.COLUMN_NAME = B.SPATIAL_COLUMN 

