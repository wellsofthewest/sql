
DECLARE
  @RowCount INT SET @RowCount =
  (SELECT COUNT(*)FROM sde.gdb_items where DatasetInfo1 = 'Shape'
  )
  -- Declare an iterator
  DECLARE
    @iterator varchar(100)
    -- Initialize the iterator
    SELECT @iterator = MIN(PHYSICALNAME) FROM SDE.GDB_ITEMS where DatasetInfo1 = 'Shape'
    -- Loop through the rows of a table
    WHILE @iterator IS NOT NULL
  BEGIN
	print @iterator
	DECLARE 
	@STMT nvarchar(2000)
	set @STMT = 'insert into sde.errors SELECT ''' + @iterator + ''', objectid FROM ' + @iterator + ' WHERE SHAPE.STIsValid() = 1';
	EXECUTE sp_executesql @STMT
      SELECT @iterator= MIN(PHYSICALNAME) FROM SDE.GDB_ITEMS WHERE @iterator < PHYSICALNAME and DatasetInfo1 = 'Shape';
    END 