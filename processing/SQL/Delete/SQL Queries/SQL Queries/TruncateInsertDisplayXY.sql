TRUNCATE TABLE sde.pipeline_points

-- Get the number of rows in the looping table
DECLARE @RowCount INT
SET @RowCount = (SELECT COUNT(*) FROM [sde].[INPUTTABLE]) 


-- Declare an iterator
DECLARE @iterator INT
-- Initialize the iterator
SELECT @iterator = MIN(OBJECTID) FROM SDE.INPUTTABLE


-- Loop through the rows of a table @myTable
WHILE @iterator is NOT NULL
BEGIN
		DECLARE @id as integer
		EXEC sde.next_rowid 'sde', 'pipeline_points', @id OUTPUT;
		INSERT INTO sde.pipeline_points
		SELECT
			@id, 
			LATITUDE, 
			LONGITUDE, 
			geometry::STPointFromText('POINT('+str(LONGITUDE, 20, 10) + ' ' + str(LATITUDE, 20, 10) + ')', 4326) as SHAPE
		FROM [sde].[INPUTTABLE] where objectid = @iterator;
        
        SELECT @Iiterator= MIN(OBJECTID) FROM SDE.INPUTTABLE WHERE @iterator < OBJECTID
END
