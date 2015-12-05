--Feature Class Combo Box drop down
SELECT ITEMS.NAME AS FC_NAME, T.REGISTRATION_ID
FROM gdb_items_vw items
INNER JOIN sde.gdb_itemtypes itemtypes
ON ITEMS.TYPE = ITEMTYPES.UUID
JOIN TABLE_REGISTRY T
on upper(items.name) = upper(t.owner || '.' || t.table_name)
WHERE ITEMTYPES.NAME                                                                                    IN ('Feature Class', 'Table')
AND xmlcast(Xmlquery('*/Versioned' passing Xmltype(items.DEFINITION) returning content) AS VARCHAR(100)) = 'true'
ORDER BY 1


--Versions drop down
Select name from versions

--Delta counts by feature class and version
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
      )

--Delata counts by feature class only (ALL Versions)
SELECT 'Updated Features' as delta, COUNT(*) as cnt
    FROM A{0}
    UNION
    SELECT 'Deleted Features' AS DELTA, COUNT(*) AS CNT
    FROM D{0}
