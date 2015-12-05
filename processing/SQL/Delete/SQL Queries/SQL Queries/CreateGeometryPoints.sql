CREATE TABLE SpatialTable( 
    id int IDENTITY (1,1),
    GeomCol1 geometry
)

-- Two counter variables.
DECLARE @cntr int;
DECLARE @cntrup int;

-- Declare a string for the geometry
DECLARE @string varchar(100);

-- A WHILE loop that uses the counter to track the quantity of inserts.
-- The counter variable is also used as a coordinate in the POINT.
SET @cntrup = 80
SET @cntr = 100;
	WHILE(@cntrup > 0)		
		WHILE(@cntr > 0)
		   BEGIN
			   -- Create the string using the counter variable value as a coordinate.
			   SET @string = 'POINT (' + CAST(@cntrup as varchar(3)) + ' '  + CAST(@cntr as varchar(4)) + ')'; -- Build up the Sql Server Geometry string
              
				  -- Insert a record into the table.
				  INSERT INTO dbo.SpatialTable(geomcol1)
				  VALUES (geometry::STGeomFromText(@string, 4326));
              
				  -- Decrease the counter.    
		SET @cntr = @cntr - 1
	SET @cntrup = @cntrup - 1
END
