CREATE VIEW dbo.Premises_View WITH SCHEMABINDING AS 
SELECT objectid, dbo_ct_sit, dbo_ct_s_1, SHAPE = case when dbo_ct_s_1 <> '' and dbo_ct_s_1 is not null then geometry::STMLineFromText('MULTILINESTRING (' + dbo.fn_GIS_ConvertSQLFormatPolygonString(dbo_ct_s_1) + ')', 4326) end 
FROM dbo.PremisesPolyline 									
WHERE dbo_ct_s_1 is not null and dbo_ct_s_1 <> '' and len(dbo_ct_s_1) > 150

CREATE UNIQUE CLUSTERED INDEX PK_objectid on dbo.Premises_View (objectid)

DROP VIEW dbo.Premises_View

ALTER TABLE dbo.PremisesPolyline Add [shape] geometry

UPDATE dbo.PremisesPolyline 
SET shape = case when dbo_ct_s_1 <> '' and dbo_ct_s_1 is not null and len(dbo_ct_s_1) > 150 then geometry::STMLineFromText('MULTILINESTRING (' + dbo.fn_GIS_ConvertSQLFormatPolygonString(dbo_ct_s_1) + ')', 4326) end

UPDATE dbo.PremisesPolyline 
SET shape = case when dbo_ct_s_1 <> '' and dbo_ct_s_1 is not null then geometry::STMLineFromText('MULTILINESTRING (' + dbo.fn_GIS_ConvertSQLFormatPolygonString(dbo_ct_s_1) + ')', 4326) end

UPDATE dbo.PremisesPolyline SET shape = shape.MakeValid()

SELECT * from dbo.PremisesPolyline
WHERE dbo_ct_s_1 <> '' and dbo_ct_s_1 is not null and len(dbo_ct_s_1) > 150






