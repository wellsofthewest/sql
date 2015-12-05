select g.name, g.definition.query('<result> {for $S in /DEFeatureClassInfo/Subtypes, 
  $n in $S/Subtype,
  $f in $n/FieldInfos,
  $x in $f/SubtypeFieldInfo
  return if ($x/DomainName = ''Material'')
  then 
  <Subtype> 
  {$n/SubtypeName}
  {$x/FieldName}
  {$x/DomainName}
  </Subtype>
  else null} </result>') from sde.gdb_items g INNER JOIN SDE.GDB_ITEMTYPES gt
ON g.TYPE         = gt.UUID
WHERE gt.NAME IN ('Feature Class','Table')
