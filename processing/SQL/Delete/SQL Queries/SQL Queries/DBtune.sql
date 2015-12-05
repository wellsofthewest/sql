SELECT sde.st_raster_util_getVersion()

select COUNT (*) from test.sde.SDE_dbtune
select COUNT (*) from utility.sde.SDE_dbtune

drop table utility.sde.SDE_dbtune
select * into utility.sde.sde_dbtune from test.sde.sde_dbtune
grant select on object::utility.sde.sde_dbtune to public