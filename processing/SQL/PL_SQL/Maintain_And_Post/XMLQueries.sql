COLUMN FC_NAME FORMAT A61
COLUMN VERSIONED FORMAT A5
COLUMN GDB_TYPE FORMAT A30

SELECT  items.name AS FC_Name, 
XMLCast(XMLQuery('*/Versioned' PASSING xmltype(items.definition) RETURNING CONTENT) as varchar(100)) as Versioned,
itemtypes.Name AS GDB_Type
FROM sde.gdb_items_vw items INNER JOIN sde.gdb_itemtypes itemtypes
ON items.Type = itemtypes.UUID
WHERE itemtypes.Name IN ('Feature Class','Table')
order by 1,3;


select objectid, column_value
FROM sde.gdb_items_vw items,
XMLTABLE('/Info/FieldName[@nm="OBJECTID"]' PASSING (XMLQuery('for $i in /DEFeatureClassInfo/GPFieldInfoExs
for $f in $i/GPFieldInfoEx
return 
<Info>
<FieldName nm="{$f/Name}" />
<TypeSDE type="{$f/FieldType}" />
</Info>'
PASSING xmltype(items.definition) RETURNING CONTENT))) xmltbl
WHERE objectid = 344;



select objectid, column_value
FROM sde.gdb_items_vw items,
XMLTABLE('/DEFeatureClassInfo/Name' PASSING xmltype(items.definition)) 

(XMLQuery('for $i in /DEFeatureClassInfo/GPFieldInfoExs
for $f in $i/GPFieldInfoEx
return 
<Info>
<FieldName nm="{$f/Name}" />
<TypeSDE type="{$f/FieldType}" />
</Info>'
PASSING xmltype(items.definition) RETURNING CONTENT))
COLUMNS firstname VARCHAR2(30) PATH 'FieldName') xmltbl
WHERE objectid = 344;







create table xmltest as
SELECT objectid, XMLQuery('for $i in /DEFeatureClassInfo/GPFieldInfoExs
for $f in $i/GPFieldInfoEx
return 
<Info>
<FieldName nm="{$f/Name}" />
<TypeSDE type="{$f/FieldType}" />
</Info>'
PASSING xmltype(items.definition) RETURNING CONTENT) as XMLQ
from sde.gdb_items_vw items
where objectid = 344;

drop table xmltest;









drop table xmltesting;

