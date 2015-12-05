--Queries an dbo-schema geodatabase in SQL Server

DECLARE @DOMAIN_NAME NVARCHAR(MAX);
SET @DOMAIN_NAME = 'Material';

DECLARE @CLASS_DEFS TABLE
(
     Name nvarchar(max),
     Definition XML
)

--Insert records to temporary record set
INSERT INTO @CLASS_DEFS
SELECT
  dbo.gdb_items.Name,
  dbo.gdb_items.Definition
FROM
-- Get the domain item's UUID.
((SELECT GDB_ITEMS.UUID AS UUID
  FROM dbo.gdb_items INNER JOIN dbo.gdb_itemtypes
  ON dbo.gdb_items.Type = dbo.gdb_itemtypes.UUID
  WHERE
    dbo.gdb_items.Name = @DOMAIN_NAME AND
    dbo.gdb_itemtypes.Name IN ('Coded Value Domain','Range Domain')) AS Domain

-- Find the relationships with the domain as the DestinationID.
INNER JOIN dbo.gdb_itemrelationships
ON Domain.UUID = dbo.gdb_itemrelationships.DestID)

-- Find the names of the origin items in the relationships.
INNER JOIN dbo.gdb_items
ON Domain.UUID = dbo.gdb_itemrelationships.DestID

-- Extract the field definitions.
SELECT
  Clasdbofs.Name AS "Class Name",
  fieldDef.value('Name[1]', 'nvarchar(max)') AS "Field Name",
  NULL AS "Subtype Name"
FROM
  @CLASS_DEFS AS Clasdbofs
CROSS APPLY
  Definition.nodes('/*/GPFieldInfoExs/GPFieldInfoEx') AS FieldDefs(fieldDef)
WHERE
  fieldDef.value('DomainName[1]', 'nvarchar(max)') = @DOMAIN_NAME

UNION

SELECT
  Clasdbofs.Name AS "Class Name",
  fieldDef.value('FieldName[1]', 'nvarchar(max)') AS "Field Name",
  fieldDef.value('(../../SubtypeName)[1]', 'nvarchar(max)') AS "Subtype Name"
FROM
  @CLASS_DEFS AS Clasdbofs
CROSS APPLY
   Definition.nodes('/*/Subtypes/Subtype/FieldInfos/SubtypeFieldInfo') AS FieldDefs(fieldDef)
WHERE
  fieldDef.value('DomainName[1]', 'nvarchar(max)') = @DOMAIN_NAME
  
  
  
  --Queries a geodatabase in Oracle

CREATE TABLE CLASS_DEFS  
(
	name varchar2(32),
	definition XMLType
);

--Insert records to temporary record set
INSERT INTO CLASS_DEFS
SELECT
  sde.gdb_items_vw.Name,
  XMLType(sde.gdb_items_vw.Definition)
FROM(
	(
		-- Get the domain item's UUID.
		SELECT GDB_ITEMS_VW.UUID AS UUID
		FROM sde.gdb_items_vw INNER JOIN sde.gdb_itemtypes
			ON sde.gdb_items_vw.Type = sde.gdb_itemtypes.UUID
		WHERE	sde.gdb_items_vw.Name = 'AncillaryRoleDomain' AND
			sde.gdb_itemtypes.Name IN ('Coded Value Domain','Range Domain')
    	) Domain
	-- Find the relationships with the domain as the DestinationID.
	INNER JOIN sde.gdb_itemrelationships
		ON Domain.UUID = sde.gdb_itemrelationships.DestID
) 
-- Find the names of the origin items in the relationships.
INNER JOIN sde.gdb_items_vw
	ON sde.gdb_items_vw.UUID = sde.gdb_itemrelationships.OriginID;

-- Extract the field definitions.
SELECT 	CLASS_DEFS.Name AS "Class Name",
	EXTRACTVALUE(fields.Column_Value, '/GPFieldInfoEx/Name') AS "Field Name",
	null AS "Subtype Name" 
FROM CLASS_DEFS, 
	TABLE(XMLSEQUENCE(Extract(CLASS_DEFS.definition, '/*/GPFieldInfoExs/GPFieldInfoEx'))) fields
UNION
SELECT table_name AS "Class Name",
	EXTRACTVALUE(subtypes_fields.Column_value, '/SubtypeFieldInfo/FieldName') as column_name,
	subtype_name AS "Subtype Name"
FROM	(	
		SELECT 	CLASS_DEFS.Name AS table_name,
			subtypes.COLUMN_VALUE XMLVal,
			EXTRACTVALUE(subtypes.COLUMN_VALUE, '/Subtype/SubtypeName') AS subtype_name,
			EXTRACTVALUE(subtypes.COLUMN_VALUE, '/Subtype/SubtypeCode') AS subtype_value
		FROM	CLASS_DEFS, 
			TABLE(XMLSEQUENCE(Extract(CLASS_DEFS.definition, '/DEFeatureClassInfo/Subtypes/Subtype'))) subtypes
	) subtypes_fields,
	TABLE(XMLSEQUENCE(subtypes_fields.XMLVal.Extract('/Subtype/FieldInfos/SubtypeFieldInfo'))) subtypes_fields;
  
DROP TABLE CLASS_DEFS;

