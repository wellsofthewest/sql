import arcpy, os

#Select feature classes that are versioned
gdb = r"Database Connections\Oracle@Mziebarth2.sde"

conn = arcpy.ArcSDESQLExecute(gdb)

fcSQL = """SELECT ITEMS.NAME AS FC_NAME, T.REGISTRATION_ID
FROM gdb_items_vw items
INNER JOIN sde.gdb_itemtypes itemtypes
ON ITEMS.TYPE = ITEMTYPES.UUID
JOIN TABLE_REGISTRY T
on upper(items.name) = upper(t.owner || '.' || t.table_name)
WHERE ITEMTYPES.NAME                                                                                    IN ('Feature Class', 'Table')
AND xmlcast(Xmlquery('*/Versioned' passing Xmltype(items.DEFINITION) returning content) AS VARCHAR(100)) = 'true'
ORDER BY 1"""

fcTBL = conn.execute(fcSQL)

for tbl,reg in fcTBL:
    print reg, tbl

fc = raw_input("Please choose object: ")

#Select versions
verSQL = """Select name from versions"""

verTBL = conn.execute(verSQL)

for ver in verTBL:
    print ver

versions = raw_input("Please choose version: ")

deltaSQL_ver = """
    SELECT 'Updated Features' as delta, COUNT(*) as cnt
    FROM A{0}
    WHERE SDE_STATE_ID IN
      (SELECT STATE_ID
      FROM STATES
      WHERE LINEAGE_NAME IN
        (SELECT LINEAGE_NAME
        FROM STATES
        WHERE STATE_ID =
          (SELECT STATE_ID FROM VERSIONS WHERE NAME = '{1}'
          )
        )
      )
    UNION
    SELECT 'Deleted Features' as delta, COUNT(*) as cnt
    FROM D{0}
    WHERE SDE_STATE_ID IN
      (SELECT STATE_ID
      FROM STATES
      WHERE LINEAGE_NAME IN
        (SELECT LINEAGE_NAME
        FROM STATES
        WHERE STATE_ID =
          (SELECT STATE_ID FROM VERSIONS WHERE NAME = '{1}'
          )
        )
      )"""

deltaSQL_all = """    SELECT 'Updated Features' as delta, COUNT(*) as cnt
    FROM A{0}
    UNION
    SELECT 'Deleted Features' as delta, COUNT(*) as cnt
    FROM D{0}"""

if versions == 'ALL':
    print conn.execute(deltaSQL_all)

else:
    print conn.execute(deltaSQL_ver.format(fc, versions))
