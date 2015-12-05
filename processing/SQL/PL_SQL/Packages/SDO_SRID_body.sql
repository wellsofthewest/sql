--------------------------------------------------------
--  File created - Monday-November-03-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body SDO_SRID
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SDE"."SDO_SRID" 

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

AS
FUNCTION INDEXNAME(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE)
  RETURN VARCHAR2
  
  /***********************************************************************
  *
  *N  {INDEXNAME}  --  What is the spatial index of the table?
  *
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *P  Purpose:
  *     This procedure tests if the sdo table specified by owner and table
  *   name has an index and then returns the name of the index.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *A  Parameters:
  *     owner_in  <IN>  ==  (owner_in) Owner of the sdo table.
  *     table_in  <IN>  ==  (table_in) Name of the sdo table.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *X  SDE Exceptions:
  *     None
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *H  History:
  *
  *    Christian Wells        11/03/2014               Original coding.
  *E
  ***********************************************************************/
  
AS
  IND VARCHAR2(61);
BEGIN

  -- Find the name of the index based on the specified owner and table_name.

  SELECT (AI.OWNER
    || '.'
    || AI.INDEX_NAME)
  INTO IND
  FROM ALL_INDEXES AI
  WHERE AI.TABLE_OWNER = OWNER_IN
  AND AI.TABLE_NAME    = TABLE_IN
  AND AI.ITYP_NAME     = 'SPATIAL_INDEX';
  RETURN IND;
  
  -- If the index is not found return "NO_INDEX"
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN 'NO_INDEX';
    
END INDEXNAME;




PROCEDURE DELETE_INDEX_ADDS(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE)

  /***********************************************************************
  *
  *N  {DELETE_INDEX_ADDS}  --  Deletes the spatial index of the delta table
  *
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *P  Purpose:
  *     This procedure tests if the sdo table specified by owner and table
  *   name has an index and then drops the index.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *A  Parameters:
  *     owner_in  <IN>  ==  (owner_in) Owner of the sdo table.
  *     table_in  <IN>  ==  (table_in) Name of the sdo table.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *X  SDE Exceptions:
  *     None
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *H  History:
  *
  *    Christian Wells        11/03/2014               Original coding.
  *E
  ***********************************************************************/
    
IS
  IND VARCHAR2(61);
  REG SDE.LAYERS.LAYER_ID%TYPE;
  RID SDE.TABLE_REGISTRY.REGISTRATION_ID%TYPE;
BEGIN

  -- Find the spatial index of the specified owner and table name then
  -- drop the index.

  SELECT REGISTRATION_ID INTO RID FROM SDE.TABLE_REGISTRY WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
  SELECT LAYER_ID INTO REG FROM SDE.LAYERS WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
  SELECT (AI.OWNER
    || '.'
    || AI.INDEX_NAME)
  INTO IND
  FROM ALL_INDEXES AI
  WHERE AI.TABLE_OWNER = OWNER_IN
  AND AI.TABLE_NAME    = ('A' || RID)
  AND AI.ITYP_NAME     = 'SPATIAL_INDEX';
  EXECUTE IMMEDIATE 'DROP INDEX ' || IND;
  
  -- If the index is not found exit without an exception.
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END DELETE_INDEX_ADDS;




PROCEDURE DELETE_INDEX_BASE(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE)

  /***********************************************************************
  *
  *N  {DELETE_INDEX_BASE}  --  Deletes the spatial index of the base table
  *
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *P  Purpose:
  *     This procedure tests if the sdo table specified by owner and table
  *   name has an index and then drops the index.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *A  Parameters:
  *     owner_in  <IN>  ==  (owner_in) Owner of the sdo table.
  *     table_in  <IN>  ==  (table_in) Name of the sdo table.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *X  SDE Exceptions:
  *     None
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *H  History:
  *
  *    Christian Wells        11/03/2014               Original coding.
  *E
  ***********************************************************************/
    
IS
  IND VARCHAR2(61);
BEGIN

  -- Find the spatial index of the specified owner and table name then
  -- drop the index.

  SELECT (AI.OWNER
    || '.'
    || AI.INDEX_NAME)
  INTO IND
  FROM ALL_INDEXES AI
  WHERE AI.TABLE_OWNER = OWNER_IN
  AND AI.TABLE_NAME    = TABLE_IN
  AND AI.ITYP_NAME     = 'SPATIAL_INDEX';
  EXECUTE IMMEDIATE 'DROP INDEX ' || IND;
  
  -- If the index is not found exit without an exception.
  
  EXCEPTION
    WHEN NO_DATA_FOUND 
    THEN NULL;
END DELETE_INDEX_BASE;




PROCEDURE CREATE_INDEX_BASE(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE)
    
  /***********************************************************************
  *
  *N  {CREATE_INDEX_BASE}  --  Creates the spatial index of the base table
  *
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *P  Purpose:
  *     This procedure finds all the registration information of the base
  *   table and then creates a spatial index.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *A  Parameters:
  *     owner_in  <IN>  ==  (owner_in) Owner of the sdo table.
  *     table_in  <IN>  ==  (table_in) Name of the sdo table.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *X  SDE Exceptions:
  *     None
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *H  History:
  *
  *    Christian Wells        11/03/2014               Original coding.
  *E
  ***********************************************************************/

IS
  REG SDE.LAYERS.LAYER_ID%TYPE;
  SHP SDE.LAYERS.SPATIAL_COLUMN%TYPE;
  IND VARCHAR(61);
  STMT VARCHAR2(2000);
BEGIN

  -- Gather the registration ID and spatial column then create a SDO
  -- spatial index

    SELECT LAYER_ID INTO REG FROM SDE.LAYERS WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
    SELECT SPATIAL_COLUMN INTO SHP FROM SDE.LAYERS WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
    SELECT (OWNER_IN || '.A' || REG || '_IX1') INTO IND FROM DUAL;
    STMT := 'CREATE INDEX ' || IND || ' ON ' || OWNER_IN || '.' || TABLE_IN || '(' || SHP 
    || ') INDEXTYPE IS MDSYS.SPATIAL_INDEX';
    EXECUTE IMMEDIATE STMT;
    
END CREATE_INDEX_BASE;




PROCEDURE CREATE_INDEX_ADDS(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE)
    
  /***********************************************************************
  *
  *N  {CREATE_INDEX_ADDS}  --  Creates the spatial index of the delta table
  *
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *P  Purpose:
  *     This procedure finds all the registration information of the delta
  *   table and then creates a spatial index.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *A  Parameters:
  *     owner_in  <IN>  ==  (owner_in) Owner of the sdo table.
  *     table_in  <IN>  ==  (table_in) Name of the sdo table.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *X  SDE Exceptions:
  *     None
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *H  History:
  *
  *    Christian Wells        11/03/2014               Original coding.
  *E
  ***********************************************************************/    
    
IS
  REG SDE.LAYERS.LAYER_ID%TYPE;
  SHP SDE.LAYERS.SPATIAL_COLUMN%TYPE;
  RID SDE.TABLE_REGISTRY.REGISTRATION_ID%TYPE;
  IND VARCHAR(61);
  STMT VARCHAR2(2000);
BEGIN

  -- Gather the registration ID and spatial column then create a SDO
  -- spatial index

  SELECT REGISTRATION_ID INTO RID FROM SDE.TABLE_REGISTRY WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
  SELECT LAYER_ID INTO REG FROM SDE.LAYERS WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
  SELECT SPATIAL_COLUMN INTO SHP FROM SDE.LAYERS WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
  SELECT (OWNER_IN || '.A' || REG || '_IX1_A') INTO IND FROM DUAL;
  STMT := 'CREATE INDEX ' || IND || ' ON ' || OWNER_IN || '.' || ('A' || RID) || '(' || SHP 
  || ') INDEXTYPE IS MDSYS.SPATIAL_INDEX';
  EXECUTE IMMEDIATE STMT;
  
END CREATE_INDEX_ADDS;
    



PROCEDURE DELETE_METADATA(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE)

  /***********************************************************************
  *
  *N  {DELETE_METADATA}  --  Deletes the SDO metadata of the specified table
  *                         in the MDSYS.SDO_GEOM_METADATA_TABLE.
  *
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *P  Purpose:
  *     This procedure finds the entries for the specified table in the 
  *   MDSYS.SO_GEOM_METADATA_TABLE and then deletes the row. This procdure
  *   includes an explicit commit.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *A  Parameters:
  *     owner_in  <IN>  ==  (owner_in) Owner of the sdo table.
  *     table_in  <IN>  ==  (table_in) Name of the sdo table.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *X  SDE Exceptions:
  *     None
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *H  History:
  *
  *    Christian Wells        11/03/2014               Original coding.
  *E
  ***********************************************************************/ 

IS
BEGIN

  -- Find the entry in the MDSYS.SDO_GEOM_METADATA_TABLE and delete it.

  DELETE
  FROM MDSYS.SDO_GEOM_METADATA_TABLE
  WHERE SDO_TABLE_NAME = TABLE_IN
  AND SDO_OWNER        = OWNER_IN;
  COMMIT;
  
END DELETE_METADATA;




PROCEDURE INSERT_METADATA(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE,
    srid_in  IN SDE.LAYERS.SRID%TYPE,
    shape_in IN SDE.LAYERS.SPATIAL_COLUMN%TYPE)
    
  /***********************************************************************
  *
  *N  {INSERT_METADATA}  --  Creates the DIMINFO for the specified table
  *                         in the MDSYS.SDO_GEOM_METADATA_TABLE.
  *
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *P  Purpose:
  *     This procedure finds the DIMINFO for the specified table 
  *   and then inserts the row into the MDSYS.SDO_GEOM_METADATA_TABLE. 
  *   This procdure includes an explicit commit.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *A  Parameters:
  *     owner_in  <IN>  ==  (owner_in) Owner of the sdo table.
  *     table_in  <IN>  ==  (table_in) Name of the sdo table.
  *     srid_in  <IN>  ==  (srid_in) SRID of the sdo table.
  *     shape_in  <IN>  ==  (shape_in) Spatial column of the sdo table.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *X  SDE Exceptions:
  *     None
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *H  History:
  *
  *    Christian Wells        11/03/2014               Original coding.
  *E
  ***********************************************************************/ 
    
IS
  STMT VARCHAR2(2000);
  CNT NUMBER;
  TBL VARCHAR2(61);
BEGIN

  -- Finds the number of rows in the specified table and then determines
  -- whether or not to create a generic grid or calculate the grid.

  SELECT (OWNER_IN || '.' || TABLE_IN) INTO TBL FROM DUAL;
  EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || TBL INTO CNT;
  
  -- If the count of the table is 0, then provide generic values.
  
  IF CNT = 0
    THEN
    STMT := 'INSERT  
    INTO MDSYS.SDO_GEOM_METADATA_TABLE    
    (SDO_OWNER,SDO_TABLE_NAME,SDO_COLUMN_NAME,SDO_DIMINFO,SDO_SRID)    
    VALUES    
    (''' || OWNER_IN || ''',''' || TABLE_IN || ''',''' || SHAPE_IN || ''',' || '      
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT(NULL, 0, 20, 0.0005), SDO_DIM_ELEMENT(NULL, 0, 20, 0.0005) )
    ,' || srid_in || ')';
    
    -- If count is other than 0, calculate the MBR for the DIMINFO.
    
  ELSE 
    STMT := 'INSERT  
    INTO MDSYS.SDO_GEOM_METADATA_TABLE    
    (SDO_OWNER,SDO_TABLE_NAME,SDO_COLUMN_NAME,SDO_DIMINFO,SDO_SRID)    
    VALUES    
    (''' || OWNER_IN || ''',''' || TABLE_IN || ''',''' || SHAPE_IN || ''',' || '      
    (SELECT MDSYS.SDO_DIM_ARRAY( MDSYS.SDO_DIM_ELEMENT(NULL, minx, maxx, 0.0005), MDSYS.SDO_DIM_ELEMENT(NULL, miny, maxy, 0.0005)) AS diminfo      
    FROM        
    (SELECT         
    TRUNC( MIN( v.x ) - 1,0) AS minx,          
    ROUND( MAX( v.x )       + 1,0) AS maxx,          
    TRUNC( MIN( v.y )       - 1,0) AS miny,          
    ROUND( MAX( v.y )       + 1,0) AS maxy        
    FROM          
    (SELECT SDO_AGGR_MBR(a.' || SHAPE_IN || ') AS mbr FROM ' || (OWNER_IN || '.' || TABLE_IN) || ' a ) b, TABLE(mdsys.sdo_util.getvertices(b.mbr)) v)      
    ),' || srid_in || ')';
  END IF;
  EXECUTE IMMEDIATE STMT;
  COMMIT;

END INSERT_METADATA;


PROCEDURE UPDATE_METADATA(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE,
    srid_in  IN SDE.LAYERS.SRID%TYPE)
    
  /***********************************************************************
  *
  *N  {UPDATE_METADATA}  --  Updates the SRID for the specified table.
  *                         in the MDSYS.SDO_GEOM_METADATA_TABLE.
  *
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *P  Purpose:
  *     This procedure updates the SRID for the specified table 
  *   and then updates the row in the MDSYS.SDO_GEOM_METADATA_TABLE. 
  *   This procdure includes an explicit commit.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *A  Parameters:
  *     owner_in  <IN>  ==  (owner_in) Owner of the sdo table.
  *     table_in  <IN>  ==  (table_in) Name of the sdo table.
  *     srid_in  <IN>  ==  (srid_in) SRID of the sdo table.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *X  SDE Exceptions:
  *     None
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *H  History:
  *
  *    Christian Wells        11/03/2014               Original coding.
  *E
  ***********************************************************************/ 
    
IS
  STMT VARCHAR2(2000);
BEGIN

  -- Find the MDSYS.SDO_GEOM_METADA_TABLE entry and update the SRID for
  -- the specified table.

  STMT := 'UPDATE MDSYS.SDO_GEOM_METADATA_TABLE SET SDO_SRID = ' || SRID_IN || ' WHERE SDO_OWNER = ''' || OWNER_IN || ''' AND SDO_TABLE_NAME = ''' || TABLE_IN || '''';
  EXECUTE IMMEDIATE STMT;
  COMMIT;

END UPDATE_METADATA;

PROCEDURE UPDATE_SRID(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE,
    srid_in  IN SDE.LAYERS.SRID%TYPE)
    
  /***********************************************************************
  *
  *N  {UPDATE_SRID}  --  Updates the SRID for the specified table.
  *
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *P  Purpose:
  *     This procedure updates the SRID for the specified table using
  *   geometry.sdo_srid. This procdure includes an explicit commit.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *A  Parameters:
  *     owner_in  <IN>  ==  (owner_in) Owner of the sdo table.
  *     table_in  <IN>  ==  (table_in) Name of the sdo table.
  *     srid_in  <IN>  ==  (srid_in) SRID of the sdo table.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *X  SDE Exceptions:
  *     None
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *H  History:
  *
  *    Christian Wells        11/03/2014               Original coding.
  *E
  ***********************************************************************/ 
    
IS
  SHP SDE.LAYERS.SPATIAL_COLUMN%TYPE;
  STMT VARCHAR2(2000);
  BEGIN
  
    -- Using the specified SRID and table name, find the spatial column and
    -- update the SRID of the geometry column.
  
    SELECT SPATIAL_COLUMN INTO SHP FROM SDE.LAYERS WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
    STMT := 'UPDATE ' || OWNER_IN || '.' || TABLE_IN || ' A SET A.' || SHP || '.SDO_SRID = ' || SRID_IN;
    EXECUTE IMMEDIATE STMT;
    COMMIT;
    
END UPDATE_SRID;




PROCEDURE UPDATE_FC(
    owner_in IN SDE.LAYERS.owner%TYPE,
    table_in IN SDE.LAYERS.table_name%TYPE,
    srid_in  IN SDE.LAYERS.SRID%TYPE)
    
  /***********************************************************************
  *
  *N  {UPDATE_FC}  --  Strings all procedures together to update the sdo
  *                 table, sde metadata, and sdo metadata.
  *
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *P  Purpose:
  *     This procedure updates the SRID for the specified feature class using
  *   the procedures from this package. This procdure includes many explicit 
  *   commits. This procedure should be run to fix SDE registered tables.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *A  Parameters:
  *     owner_in  <IN>  ==  (owner_in) Owner of the sdo table.
  *     table_in  <IN>  ==  (table_in) Name of the sdo table.
  *     srid_in  <IN>  ==  (srid_in) SRID of the sdo table.
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *X  SDE Exceptions:
  *     None
  *E
  *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  *
  *H  History:
  *
  *    Christian Wells        11/03/2014               Original coding.
  *E
  ***********************************************************************/ 
    
IS
  VER VARCHAR2(5);
  SHP SDE.LAYERS.SPATIAL_COLUMN%TYPE;
  RID SDE.TABLE_REGISTRY.REGISTRATION_ID%TYPE;
  REG SDE.LAYERS.LAYER_ID%TYPE;
  IMV SDE.TABLE_REGISTRY.IMV_VIEW_NAME%TYPE;
  STMT VARCHAR2(2000);
  LSR SDE.LAYERS.SRID%TYPE;
  MET NUMBER;
  DLT VARCHAR2(30);
  BEGIN
  
    -- Select regristation ID, spatial columns, versioned status, layer SRID and perform the following:
    -- Drop Index of base table
    -- Update the SRID of base table
    -- Update SDO metadata (Insert the data if not present)
    -- Update SDE.Layers SRID info
    -- Create Index of base table
    -- If the feature class is versioned:
    -- Drop Index of delta tables (Adds)
    -- Update SRID of delta tables (Adds)
    -- Update SDO metadata of delta tables (Adds) Insert the data if not present)
    -- Create Index of delta tables (Adds)
    -- If the MV view is in the SDO metadata:
    -- Update SDO metadata of MV view. Insert the data if not present)
  
    SELECT REGISTRATION_ID INTO RID FROM SDE.TABLE_REGISTRY WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
    SELECT SPATIAL_COLUMN INTO SHP FROM SDE.LAYERS WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
    SELECT SDE.GDB_UTIL.IS_VERSIONED(OWNER_IN, TABLE_IN) INTO VER FROM DUAL;
    SELECT SRID INTO LSR FROM SDE.LAYERS WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
    SELECT COUNT(*) INTO MET FROM MDSYS.SDO_GEOM_METADATA_TABLE WHERE SDO_OWNER = OWNER_IN AND SDO_TABLE_NAME = TABLE_IN;
    STMT := 'CALL SDE.SDO_SRID.DELETE_INDEX_BASE(''' || OWNER_IN || ''',''' || TABLE_IN || ''')';
    EXECUTE IMMEDIATE STMT;
    STMT := 'CALL SDE.SDO_SRID.UPDATE_SRID(''' || OWNER_IN || ''',''' || TABLE_IN || ''',' || SRID_IN || ')';
    EXECUTE IMMEDIATE STMT;
    IF MET = 1 THEN
      STMT := 'CALL SDE.SDO_SRID.UPDATE_METADATA(''' || OWNER_IN || ''',''' || TABLE_IN || ''',' || SRID_IN || ')';
      EXECUTE IMMEDIATE STMT;
    ELSE
      STMT := 'CALL SDE.SDO_SRID.INSERT_METADATA(''' || OWNER_IN || ''',''' || TABLE_IN || ''',' || SRID_IN || ',''' || SHP || ''')';
      EXECUTE IMMEDIATE STMT;
    END IF;
    STMT := 'CALL SDE.LAYERS_UTIL.UPDATE_SPREF_AUTH_SRID(' || LSR || ',' || SRID_IN || ',' || '''ORACLE000''' || ')';
    EXECUTE IMMEDIATE STMT;
    STMT :=  'CALL SDE.SDO_SRID.CREATE_INDEX_BASE(''' || OWNER_IN || ''',''' || TABLE_IN || ''')';
    EXECUTE IMMEDIATE STMT;
    IF VER = 'TRUE' THEN
      SELECT IMV_VIEW_NAME INTO IMV FROM SDE.TABLE_REGISTRY WHERE OWNER = OWNER_IN AND TABLE_NAME = TABLE_IN;
      SELECT ('A' || RID) INTO DLT FROM DUAL;
      SELECT COUNT(*) INTO MET FROM MDSYS.SDO_GEOM_METADATA_TABLE WHERE SDO_OWNER = OWNER_IN AND SDO_TABLE_NAME = DLT;
      STMT := 'CALL SDE.SDO_SRID.DELETE_INDEX_ADDS(''' || OWNER_IN || ''',''' || TABLE_IN || ''')';
      EXECUTE IMMEDIATE STMT;
      STMT := 'CALL SDE.SDO_SRID.UPDATE_SRID(''' || OWNER_IN || ''',''' || DLT || ''',' || SRID_IN || ')';
      EXECUTE IMMEDIATE STMT;
      IF MET = 1 THEN
        STMT := 'CALL SDE.SDO_SRID.UPDATE_METADATA(''' || OWNER_IN || ''',''' || DLT || ''',' || SRID_IN || ')';
        EXECUTE IMMEDIATE STMT;
      ELSE
        STMT := 'CALL SDE.SDO_SRID.INSERT_METADATA(''' || OWNER_IN || ''',''' || DLT || ''',' || SRID_IN || ',''' || SHP || ''')';
        EXECUTE IMMEDIATE STMT;
      END IF;
    STMT := 'CALL SDE.LAYERS_UTIL.UPDATE_SPREF_AUTH_SRID(' || LSR || ',' || SRID_IN || ',' || '''ORACLE000''' || ')';
    EXECUTE IMMEDIATE STMT;
    STMT :=  'CALL SDE.SDO_SRID.CREATE_INDEX_ADDS(''' || OWNER_IN || ''',''' || TABLE_IN || ''')';
    EXECUTE IMMEDIATE STMT;
    SELECT COUNT(*) INTO MET FROM MDSYS.SDO_GEOM_METADATA_TABLE WHERE SDO_OWNER = OWNER_IN AND SDO_TABLE_NAME = IMV;
      IF MET = 1 THEN
        STMT := 'CALL SDE.SDO_SRID.UPDATE_METADATA(''' || OWNER_IN || ''',''' || IMV || ''',' || SRID_IN || ')';
        EXECUTE IMMEDIATE STMT;
      ELSE
        STMT := 'CALL SDE.SDO_SRID.INSERT_METADATA(''' || OWNER_IN || ''',''' || IMV || ''',' || SRID_IN || ',''' || SHP || ''')';
        EXECUTE IMMEDIATE STMT;
      END IF;
    END IF;
END UPDATE_FC;




























END SDO_SRID;

/

