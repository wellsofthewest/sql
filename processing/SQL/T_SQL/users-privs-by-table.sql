--Privileges by table

SELECT 
UPPER(GRANTEE) as Grantee,
RIGHT(path, len(path) - 1) as Table_Name,
  CASE "SL"
    WHEN 1
    THEN 'X'
    ELSE ''
  END AS "SELECT",
  CASE "IN"
    WHEN 1
    THEN 'X'
    ELSE ''
  END AS "INSERT",
  CASE "UP"
    WHEN 1
    THEN 'X'
    ELSE ''
  END AS "UPDATE",
  CASE "DL"
    WHEN 1
    THEN 'X'
    ELSE ''
  END AS "DELETE"
FROM
  (SELECT USER_NAME(grantee_principal_id) grantee,
    privs.type PRIVILEGE,
    schema_name(obj.schema_id) AS OWNER,
    object_name(obj.object_id) AS TABLE_NAME,
	items.path
  FROM sys.database_permissions privs
  JOIN sys.all_objects obj
  ON privs.major_id = obj.object_id
  JOIN sde.SDE_table_registry reg --Change to DBO if you are not using the SDE schema
  ON (schema_name(obj.schema_id) + '.' + object_name(obj.object_id)) = (reg.owner + '.' + reg.table_name)
  join sde.gdb_items items
  on upper(reg.database_name + '.' + reg.owner + '.' + reg.table_name) = Upper(items.Name)
  WHERE class                                                        = 1
  AND state                                                         IN ('G', 'W')
  ) AS all_privs pivot (COUNT(privilege) FOR PRIVILEGE              IN ("SL", "IN", "UP", "DL")) AS PIV
ORDER BY 2,1,3
