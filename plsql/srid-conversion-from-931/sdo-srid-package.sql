--------------------------------------------------------
--  File created - Monday-November-03-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package SDO_SRID
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "SDE"."SDO_SRID" 
/***********************************************************************
*
*N  {sdo_srid.sps}  --  Interface for sdo srid correction
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This PL/SQL package specification defines procedures to perform
*   DDL operations on sdo tables that participate in SDE.   
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*H  History:
*
*    Christian Wells        11/03/2014               Original coding.
*E
***********************************************************************/
IS
  /* Procedures and functions. */

   -- The following functions perform DDL operations for sdo tables
   -- stored in the SDE.LAYERS table.  These procedures occur in an
   -- autonomous transaction.
   
FUNCTION INDEXNAME(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE)
  RETURN VARCHAR2;
PROCEDURE DELETE_INDEX_ADDS(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE);
PROCEDURE DELETE_INDEX_BASE(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE);
PROCEDURE CREATE_INDEX_ADDS(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE);
PROCEDURE CREATE_INDEX_BASE(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE);
  
   -- The following functions perform DML operations for sdo tables
   -- stored in the SDE.LAYERS table.  These procedures all issue a COMMIT
   -- on success.
   
PROCEDURE DELETE_METADATA(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE);
PROCEDURE INSERT_METADATA(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE,
    srid_in  IN SDE.LAYERS.SRID%TYPE,
    shape_in IN SDE.LAYERS.SPATIAL_COLUMN%TYPE);
PROCEDURE UPDATE_SRID(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE,
    srid_in  IN SDE.LAYERS.SRID%TYPE);
PROCEDURE UPDATE_METADATA(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE,
    srid_in  IN SDE.LAYERS.SRID%TYPE);
    
   -- The following functions perform multiple DDL/DML operations for sdo tables
   -- stored in the SDE.LAYERS table.  These procedures all issue a COMMIT
   -- on success. These procedures occur in an autonomous transaction.
    
PROCEDURE UPDATE_FC(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE,
    srid_in  IN SDE.LAYERS.SRID%TYPE);
    
    
END SDO_SRID;

/

