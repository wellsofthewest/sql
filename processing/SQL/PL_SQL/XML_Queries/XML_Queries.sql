/***********************************************************************
*
*N  fieldlist.SQL  --  List Esri Field Types
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This script serves to describe feature classes within the GDB_ITEMS
*	table by listing the name and type of Esri field as this differs
*	from DBMS field types. Requires ST_SHAPELIB to be set up and working.
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*H  History:
*
*    Christian Wells        11/03/2014               Original coding.
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*V  Versions Supported:
*   EGDB: 10.0 and above
*	DBMS: Oracle
*	DBMS Version: All
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*T  Tags:
*   XML, Fields, Oracle, Feature Class
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*R  Resources:
*   XMLQUERY:
*	http://docs.oracle.com/cd/B19306_01/server.102/b14200/functions224.htm
*E
***********************************************************************/


--Return all fields and types for features classes

SELECT ITEMS.PHYSICALNAME,
  ITEMS.OBJECTID,
  XMLTBL.FNAME, --Field Name
  SUBSTR(XMLTBL.FTYPE, 14) AS FTYPE --Esri Field Type
FROM SDE.GDB_ITEMS_VW ITEMS,
  XMLTABLE('/Info' PASSING --Create XML table from XMLQUERY
  (
  --Query XML for information on fields
  XMLQUERY('for $i in /DEFeatureClassInfo/GPFieldInfoExs
              for $f in $i/GPFieldInfoEx
                return <Info nm="{$f/Name}" fType="{$f/FieldType}" />'
            PASSING XMLTYPE(ITEMS.DEFINITION) RETURNING CONTENT)
  )
  COLUMNS FNAME VARCHAR(30) PATH '@nm', FTYPE VARCHAR(30) PATH '@fType') XMLTBL
WHERE items.type = '{70737809-852C-4A03-9E22-2CECEA5B9BFA}';

--Return all fields and domains for feature classes

select items.physicalname, items.objectid, xmltbl.Fname, xmltbl.Ftype as FDomain
FROM sde.gdb_items_vw items,
XMLTABLE('/Info' PASSING (XMLQuery('for $i in /DEFeatureClassInfo/GPFieldInfoExs
for $f in $i/GPFieldInfoEx
return
<Info nm="{$f/Name}" fDomain="{$f/DomainName}"/>'
PASSING xmltype(items.definition) RETURNING CONTENT))
COLUMNS FName varchar(30) PATH '@nm',
FType varchar(30) PATH '@fDomain') xmltbl
WHERE items.type = '{70737809-852C-4A03-9E22-2CECEA5B9BFA}';


--Return orphaned domains

SELECT items.physicalname,
  items.objectid,
  xmltbl.Fname,
  xmltbl.Ftype AS FDomain
FROM sde.gdb_items_vw items,
  XMLTABLE('/Info' PASSING (XMLQuery('for $i in /DEFeatureClassInfo/GPFieldInfoExs
for $f in $i/GPFieldInfoEx
return
<Info nm="{$f/Name}" fDomain="{$f/DomainName}"/>' PASSING xmltype(items.definition) RETURNING CONTENT)) COLUMNS FName VARCHAR(30) PATH '@nm', FTYPE VARCHAR(30) PATH '@fDomain') XMLTBL
WHERE ITEMS.TYPE     IN ('{70737809-852C-4A03-9E22-2CECEA5B9BFA}', '{CD06BC3B-789D-4C51-AAFA-A467912B8965}')
AND XMLTBL.FTYPE NOT IN
  (SELECT NAME
  FROM GDB_ITEMS
  WHERE TYPE IN ('{8C368B12-A12E-4C7E-9638-C9C64E69E98F}', '{C29DA988-8C3E-45F7-8B5C-18E51EE7BEB4}')
  )
AND XMLTBL.FTYPE IS NOT NULL
