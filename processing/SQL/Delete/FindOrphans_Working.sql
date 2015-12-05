SET SERVEROUTPUT ON
DECLARE

CURSOR GDB
IS
  SELECT PHYSICALNAME
  FROM GDB_ITEMS GI
  WHERE PHYSICALNAME NOT IN
    ( SELECT (l.owner || '.' || l.table_name) AS FeatureClass FROM layers l
  INTERSECT
  SELECT (t.owner || '.' || t.table_name) AS FeatureClass FROM table_registry t
  INTERSECT
  SELECT g.physicalname AS FeatureClass FROM gdb_items g
    )
  AND GI.TYPE IN ('{70737809-852C-4A03-9E22-2CECEA5B9BFA}');
CURSOR LYR
IS
  SELECT (LY.OWNER
    || '.'
    || LY.TABLE_NAME) AS FC
  FROM LAYERS LY
  WHERE (LY.OWNER
    || '.'
    || LY.TABLE_NAME) NOT IN
    ( SELECT (l.owner || '.' || l.table_name) AS FeatureClass FROM layers l
  INTERSECT
  SELECT (t.owner || '.' || t.table_name) AS FeatureClass FROM table_registry t
  INTERSECT
  SELECT g.physicalname AS FeatureClass FROM gdb_items g
    )
  AND LY.table_name NOT LIKE 'GDB%'
  AND LY.table_name NOT LIKE '%_H';
    
    
    
  CURSOR TBL
  IS
    SELECT (TR.OWNER
      || '.'
      || TR.TABLE_NAME)
    FROM TABLE_REGISTRY TR
    WHERE TR.table_name NOT LIKE 'GDB%'
    AND TR.table_name NOT LIKE '%_H';
  sql_stmt VARCHAR2(200);
BEGIN
  FOR ITEM IN GDB
  LOOP
  INSERT INTO SDE.ORPHANS (GDB_ITEMS) VALUES (ITEM.PHYSICALNAME);
  COMMIT;
  END LOOP;
  FOR ITEM IN LYR
  LOOP
  IF ITEM.FC IN (SELECT GDB_ITEMS FROM SDE.ORPHANS)
  THEN 
  UPDATE SDE.ORPHANS SET LAYERS = GDB_ITEMS;
  ELSE 
  INSERT INTO SDE.ORPHANS (LAYERS) VALUES (ITEM.FC);
  END IF;
  COMMIT;
  END LOOP;
END;
/



  CREATE TABLE SDE.ORPHANS
    (
      GDB_ITEMS      VARCHAR(61),
      LAYERS         VARCHAR(61),
      TABLE_REGISTRY VARCHAR(61)
    );
    
    
    SELECT * FROM SDE.ORPHANS;
    
    TRUNCATE TABLE ORPHANS;