--User Role Membership

SELECT "User",
  "User Type",
  CASE "DATA_MGT"
    WHEN 1
    THEN 'X'
    ELSE ''
  END AS "DATA_MGT",
  CASE "db_accessadmin"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "DB_ACCESSADMIN",
  CASE "db_datareader"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "DB_DATAREADER",
  CASE "db_datawriter"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "DB_DATAWRITER",
  CASE "db_ddladmin"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "DB_DDLADMIN",
  CASE "db_owner"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "DB_OWNER",
  CASE "Db_securityadmin"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "DB_SECURITYADMIN",
  CASE "edm_role"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "EDM_ROLE",
  CASE "GIS_ADMIN"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "GIS_ADMIN",
  CASE "GRID_ETL"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "GRID_ETL",
  CASE "MAPPING"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "MAPPING",
  CASE "RAILROAD"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "RAILROAD",
  CASE "READ_ONLY"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "READ_ONLY",
  CASE "ROAD_RECS"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "ROAD_RECS",
  CASE "ROUTES"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "ROUTES",
  CASE "TRAFFIC"
    WHEN 1
    THEN 'X'
    ELSE ''
  END "TRAFFIC"
FROM
  (SELECT d.name AS "User",
    d.type_desc  AS "User Type",
    s.name rname,
    is_rolemember(s.name, d.name) AS mem
  FROM sys.database_principals d,
    sysusers s
  WHERE s.issqlrole                          = 1
  AND s.name                                <> 'PUBLIC'
  AND d.type                                <> 'r'
  ) AS ROLE_PRIVS PIVOT (SUM(MEM) FOR RNAME IN (DATA_MGT,DB_ACCESSADMIN,DB_DATAREADER,DB_DATAWRITER,DB_DDLADMIN,DB_OWNER,DB_SECURITYADMIN,EDM_ROLE,GIS_ADMIN,GRID_ETL,MAPPING,RAILROAD,"READ_ONLY",ROAD_RECS,ROUTES,TRAFFIC)) AS P2
ORDER BY 1