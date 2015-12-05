CREATE TABLE #SDO_TEST
  ( RID INT IDENTITY(1,1) NOT NULL, WKB VARBINARY(MAX)
  );
  
INSERT INTO #SDO_TEST
  (WKB
  )
SELECT WKB
FROM OPENQUERY( FURY,'select mdsys.sdo_util.to_wkbgeometry(a.shape) wkb from sde.alexsdo a');

DECLARE
  @ITERATOR INT
  -- Initialize the iterator
  SELECT @ITERATOR = MIN(RID) FROM #SDO_TEST
  -- Loop through the rows of a table
  WHILE @ITERATOR IS NOT NULL
BEGIN
  DECLARE
    @ID AS INTEGER EXEC SDE.NEXT_ROWID 'sde',
    'SDO_FC',
    @ID OUTPUT;
    INSERT INTO SDE.SDO_FC
      (OBJECTID, SHAPE
      )
    SELECT @id,
      GEOMETRY::STGeomFromWKB(WKB, 4269) AS SHAPE
    FROM #SDO_TEST
    WHERE RID       = @ITERATOR;
    SELECT @ITERATOR= MIN(RID) FROM #SDO_TEST WHERE @ITERATOR < RID
  END ;

  
DROP TABLE #SDO_TEST;

truncate table #sdo_test;