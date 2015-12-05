-- Get the number of rows in the looping table
DECLARE @RowCount INT
SET @RowCount = (SELECT COUNT(*) FROM sde.INPUT_TABLE) 


-- Declare an iterator
DECLARE @iterator INT
-- Initialize the iterator
SELECT @iterator = MIN(OBJECTID) FROM SDE.INPUT_TABLE


-- Loop through the rows of a table @myTable
WHILE @iterator is NOT NULL
BEGIN
		DECLARE @id as integer
		EXEC sde.next_rowid 'sde', 'points', @id OUTPUT;
		INSERT INTO sde.points
		SELECT
			@id, 
			geometry::STPointFromText('POINT('+str(POINT_X, 38, 8) + ' ' + str(POINT_Y, 38, 8) + ')', 0) as SHAPE
		FROM [sde].[INPUT_TABLE] where objectid = @iterator;
        
        SELECT @Iiterator= MIN(OBJECTID) FROM SDE.INPUT_TABLE WHERE @iterator < OBJECTID
END
