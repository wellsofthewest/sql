select * from sde.TREE 
where UnitID not in (select UnitID from sde.TREEOLD)


select count(GlobalID), GlobalID from sde.tree
group by GlobalID
order by 1 desc;



select t.UnitID from sde.tree t join sde.treeold o
on t.UnitID = o.UnitID
where t.unitid <> '' 
and t.shape.STIntersects(o.shape) = 0

select t.UnitID, t.AssetType, o.AssetType from sde.tree t join sde.treeold o
on t.UnitID = o.UnitID
where t.unitid <> '' 
and (t.AssetType <> o.AssetType)

select nametype from sde.tree

select objectid from sde.tree;

update t
set 
t.tstrConcan = o.tstrConcan,
t.SPcode = o.SPcode,
t.Genus = o.Genus,
t.Species = o.Species,
t.Cultivar = o.Cultivar,
t.SciName = o.SciName,
t.ComName = o.ComName,
t.NameType = o.NameType,
t.MedianID = o.MedianID,
t.FeatCount = o.FeatCount,
t.GIS_Notes = o.GIS_Notes,
t.CompType = o.CompType,
t.CompKey = o.CompKey,
t.UnitID = o.UnitID,
t.PruneZone = o.PruneZone,
t.Eng_ID = o.Eng_ID,
t.AtlasShtNo = o.AtlasShtNo,
t.AssetType = o.AssetType,
t.PositCode = o.PositCode,
t.Count_ = o.Count_,
t.LLDistrict = o.LLDistrict,
t.HPruneZone = o.HPruneZone,
t.Condition = o.Condition,
t.STREET = o.STREET,
t.POINT_X = o.POINT_X,
t.POINT_Y = o.POINT_Y,
t.SITENAME = o.SITENAME,
t.SITECODE = o.SITECODE,
t.TYPE = o.TYPE,
t.SyncHansen = o.SyncHansen,
t.GISCOMMENT = o.GISCOMMENT,
t.MaintBy = o.MaintBy,
t.STATUS = o.STATUS,
t.PlantDate = o.PlantDate,
t.Owner = o.Owner,
t.Quad = o.Quad,
t.Position_ = o.Position_,
t.DiamRange = o.DiamRange,
t.HT = o.HT,
t.STNO = o.STNO,
t.TreeActivity = o.TreeActivity,
t.UnitType = o.UnitType,
t.ModifiedBy = o.ModifiedBy,
t.ModifiedDate = o.ModifiedDate,
t.CreatedBy = o.CreatedBy,
t.CreatedDate = o.CreatedDate,
t.GlobalID = o.GlobalID,
t.Shape = o.Shape
from sde.tree t
join sde.treeold o
on t.unitid = o.unitid


