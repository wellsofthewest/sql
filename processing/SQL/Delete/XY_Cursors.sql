--SQL SERVER LOOP

-- Get the number of rows in the looping table
DECLARE
  @RowCount INT SET @RowCount =
  (SELECT COUNT(*)FROM sde.INPUT_TABLE
  )
  -- Declare an iterator
  DECLARE
    @iterator INT
    -- Initialize the iterator
    SELECT @iterator = MIN(OBJECTID) FROM SDE.INPUT_TABLE
    -- Loop through the rows of a table
    WHILE @iterator IS NOT NULL
  BEGIN
    DECLARE
      @id AS INTEGER EXEC sde.next_rowid 'sde', 'points', @id OUTPUT;
      INSERT INTO sde.POINTS
        (OBJECTID, Shape
        )
      SELECT @id,
        geometry::STPointFromText( 'POINT('+str(POINT_X, 38, 8) + ' ' + str(POINT_Y, 38, 8) + ')', 2286) AS SHAPE
      FROM sde.INPUT_TABLE
      WHERE objectid  = @iterator;
      SELECT @iterator= MIN(OBJECTID) FROM SDE.INPUT_TABLE WHERE @iterator < OBJECTID
    END 
	
	
	
--ORACLE SDO CURSOR

SET SERVEROUTPUT ON
-- Declare a cursor
DECLARE
  CURSOR points
  IS
    SELECT * FROM sde.input_table;
  --Loop through the cursor
BEGIN
  FOR pt IN points
  LOOP
    INSERT
    INTO SDE.POINTS
      (
        OBJECTID,
        SHAPE
      )
      VALUES
      (
        sde.gdb_util.next_rowid('sde', 'points'),
        MDSYS.SDO_GEOMETRY(2001,2286,MDSYS.SDO_POINT_TYPE(pt.point_x, pt.point_y,NULL),NULL,NULL)
      );
  END LOOP;
  COMMIT;
END;
/



--ORACLE ST CURSOR

SET SERVEROUTPUT ON
-- Declare a cursor
DECLARE
  CURSOR points
  IS
    SELECT * FROM sde.input_table;
  --Loop through the cursor
BEGIN
  FOR pt IN points
  LOOP
    INSERT
    INTO SDE.POINTS
      (
        OBJECTID,
        SHAPE
      )
      VALUES
      (
        sde.gdb_util.next_rowid('sde', 'points'),
        sde.ST_Point(pt.point_x,pt.point_y, 2286)
      );
  END LOOP;
  COMMIT;
END;
/ 