Select Subtypename from
(SELECT	EXTRACTVALUE(fields.column_value, '/Subtype/SubtypeName') AS Subtypename,
	EXTRACTVALUE(fields.column_value, '/Subtype/SubtypeCode') AS Code
  FROM
	sde.gdb_items_vw,
	TABLE(XMLSEQUENCE(XMLType(Definition).Extract('/DEFeatureClassInfo/Subtypes/Subtype'))) fields
  WHERE name = 'MSD.ssGravityMain'), MSD.swgravitymain_vw MV
where
MV.subtype = Code
and MV.mxassetnum = vAssetNum;


This replaces the 9.3.1. method where the statement would have looked like:

         SELECT ST.subtypename
           into vSubType
           from sde.gdb_subtypes          ST,
                sde.gdb_objectclasses     OC,
                msd.swgravitymain_vw      MV
          where MV.Subtype = ST.Subtypecode
            and ST.classID = OC.ID
            and ST.Subtypecode = MV.subtype
            and OC.name = 'swGravityMain'
            and MV.mxassetnum = vAssetNum;