
--GDB_ITEMS:

SELECT PHYSICALNAMEFROM GDB_ITEMS gi WHERE PHYSICALNAME NOT IN  ( SELECT (l.owner || '.' || l.table_name) AS FeatureClass FROM layers l  INTERSECT  SELECT (t.owner || '.' || t.table_name) AS FeatureClass FROM table_registry t  INTERSECT  SELECT g.physicalname AS FeatureClass FROM gdb_items g  )AND GI.TYPE IN ('{70737809-852C-4A03-9E22-2CECEA5B9BFA}');

--TABLE_REGISTRY:

SELECT (TR.owner || '.' || TR.table_name)FROM TABLE_REGISTRY TR WHERE (TR.owner || '.' || TR.table_name) NOT IN  ( SELECT (l.owner || '.' || l.table_name) AS FeatureClass FROM layers l  INTERSECT  SELECT (t.owner || '.' || t.table_name) AS FeatureClass FROM table_registry t  INTERSECT  SELECT g.physicalname AS FeatureClass FROM gdb_items g  )AND TR.table_name NOT LIKE 'GDB%' AND TR.table_name NOT LIKE '%_H';

--LAYERS:

SELECT (lY.owner || '.' || lY.table_name)FROM LAYERS LY WHERE (lY.owner || '.' || lY.table_name) NOT IN  ( SELECT (l.owner || '.' || l.table_name) AS FeatureClass FROM layers l  INTERSECT  SELECT (t.owner || '.' || t.table_name) AS FeatureClass FROM table_registry t  INTERSECT  SELECT g.physicalname AS FeatureClass FROM gdb_items g  )AND LY.table_name NOT LIKE 'GDB%'AND LY.table_name NOT LIKE '%_H';