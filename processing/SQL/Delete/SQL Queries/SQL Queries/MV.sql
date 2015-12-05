VARIABLE mv_version NVARCHAR2(10); 
EXEC :mv_version := 'TESTEDITS';
EXEC sde.version_user_ddl.create_version ('sde.DEFAULT', :mv_version, sde.version_util.C_take_name_as_given, sde.version_util.C_version_public, 'multiversioned view edit version');


EXEC sde.version_util.set_current_version('TESTEDITS');
EXEC sde.version_user_ddl.edit_version('TESTEDITS',1);
delete from testpoly_mv where objectid='4';
commit;
EXEC sde.version_user_ddl.edit_version('TESTEDITS',2);
EXEC sde.version_user_ddl.edit_version('TESTEDITS',1);
update testpoly_mv set shapetype='circle' where shapetype='square';
EXEC sde.version_user_ddl.edit_version('TESTEDITS',2);

EXEC sde.version_util.set_current_version('DEFAULT');
select count(*) from testpoly_mv;