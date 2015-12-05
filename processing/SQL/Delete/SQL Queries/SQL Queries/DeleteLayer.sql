select layer_id from sde.SDE_layers where table_name = 'testpt'
select ID from sde.GDB_OBJECTCLASSES where Name = 'testpt'
select Registration_ID from sde.SDE_table_registry where table_name = 'testpt'
select g_table_name from sde.SDE_geometry_columns where f_table_name = 'testpt'
drop table sde.testpt
drop table sde.f17
drop table sde.s17
delete from sde.GDB_USERMETADATA where name = 'testpt'
delete from sde.GDB_FEATURECLASSES where ObjectClassID = '452'
delete from sde.GDB_OBJECTCLASSES where Name = 'testpt'
delete from sde.SDE_geometry_columns where f_table_name = 'testpt'
delete from sde.sde_layers where table_name = 'testpt'
drop table sde.i93
delete from sde.GDB_FIELDINFO where ClassID = '452'
delete from sde.SDE_table_registry where table_name = 'testpt'
