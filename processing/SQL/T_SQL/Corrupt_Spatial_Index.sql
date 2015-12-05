--From the SQL Server Profiler trace (Exceptions must be turned on) find the following error code:

Unable to find index entry in index ID 1, of table 1250103494, in database 'GIS_ILAW_West'. The indicated index
is corrupt or there is a problem with the current update plan. Run DBCC CHECKDB or DBCC CHECKTABLE. If the
problem persists, contact product support.

--Using the table ID number, find its object_name using the Object_name(ID int) function
select object_name(1250103494);

--Since this points to a spatial index table, find it in the sys.internal_tables view
select * from sys.internal_tables where name = object_name(1250103494);

--From this view, find the parent object_name
select object_name(parent_object_id) from sys.internal_tables where name = object_name(1250103494);

--Using the parent table information, drop and create the index
USE GIS_ILAW_West 
GO

DROP INDEX S1_idx ON sde.GDB_ITEMS 
GO 

CREATE SPATIAL INDEX S1_idx ON sde.GDB_ITEMS ( Shape )USING GEOMETRY_GRID
WITH
  (
    BOUNDING_BOX           =(-400, -90, 400, 90),
    GRIDS                  =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM),
    CELLS_PER_OBJECT       = 16,
    PAD_INDEX              = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    SORT_IN_TEMPDB         = OFF,
    DROP_EXISTING          = OFF,
    ONLINE                 = OFF,
    ALLOW_ROW_LOCKS        = ON,
    ALLOW_PAGE_LOCKS       = ON
  )
  ON PRIMARY 
GO

