CREATE TRIGGER SDE.UPDATE_FEMA
ON SDE.FEMA
AFTER UPDATE
AS
declare @r geometry
declare @point1 geometry
declare @point3 geometry
declare @minx float
declare @miny float
declare @maxx float
declare @maxy float
declare @cmd varchar
set @r = (select shape.STEnvelope() from sde.fema where PanelNumbe='0420')
set @point1 = (select @r.STPointN(1))
set @point3 = (select @r.STPointN(3))
set @minx = @point1.STX*1.1
set @miny = @point1.STY*1.1
set @maxx = @point3.STX*1.1
set @maxy = @point3.STY*1.1
set @cmd = 'C:/Python27/ArcGIS10.2/python.exe C:/PyTest.py ' + str(@minx)
select @cmd
EXEC xp_cmdshell @cmd