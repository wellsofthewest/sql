insert into PARCEL_ATTRIBUTE_VW (PARCELID, PARCELOWNER, ADDRESS, ZIPCODE, CITY, STATE, GLOBALID) 
values ( '1', 'Minnie', '1 Disney Way', '12345', 'Disneyland', 'CA', sde.version_user_ddl.retrieve_guid);

insert into PARCELPT_VW (PARCELID, SHAPE, GLOBALID)
values ('1',sde.ST_PointFromText ('point (-117.9191 33.8151)', 4326), sde.version_user_ddl.retrieve_guid); 

commit;


EXEC sde.version_util.set_current_version('myedits');

EXEC sde.version_user_ddl.edit_version('myedits',1);

insert into PARCEL_ATTRIBUTE_VW (PARCELID, PARCELOWNER, ADDRESS, ZIPCODE, CITY, STATE, GLOBALID) 
values ( '72', 'Grumpy', '72 Disney Way', '12345', 'Disneyland', 'CA', sde.version_user_ddl.retrieve_guid);

insert into PARCELPT_VW (PARCELID, SHAPE, GLOBALID)
values ('72',sde.ST_PointFromText ('point (-119 34)', 4326), sde.version_user_ddl.retrieve_guid); 

COMMIT;

EXEC sde.version_user_ddl.edit_version('myedits',2);

exec sde.version_util.set_default();

update parcelpt_vw
set parcelid = 12345
where objectid = 20;