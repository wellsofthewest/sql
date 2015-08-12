/***********************************************************************
*
*N  list-fc-by-spatial-type.sql  --  Feature Class Spatial Types
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This script serves as a method for returning the spatial type of
*   feature classes registered with the SDE repository tables.
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*H  History:
*
*    Christian Wells        07/27/2015               Original coding.
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*V  Versions Supported:
*   EGDB: All
*   DBMS: Oracle
*   DBMS Version: 11g and above (Only enter DBMS version if it requires a specific version)
*   ST_SHAPELIB: No requirement
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*T  Tags:
*   Oracle, Feature Class, Spatial Type, List  
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*N  Notes:
*   This script must be run with privileges to the SDE repository.
*E
***********************************************************************/

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
