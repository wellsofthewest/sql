New Century/Chevron:

OBJECTID not IN (8001,8002,8003)

--Test:
create table staging.centerline_demo as select * from staging.centerline;

--Where is the issue coming from?

--Get the number of points per object
select objectid, sde.st_numpoints(shape) from staging.centerline_demo order by 2,1;

--Delete any features with 0 points (NULL geometries however, are supported by Esri)
delete from centerline_demo where sde.st_numpoints(shape) = 0;

commit;

--Verify that the issue still occurs in ArcMap

--Review the shape information in SQL
select shape from staging.centerline_demo;

--Nothing stands out here

--Review the constructor
select sde.st_astext(shape) from staging.centerline_demo;
--Notice the three features (8001,8002,8003) have coordinate pairs set to -400,-400

--Verify all points in the features are doing this
select sde.st_pointn(shape, 9) from staging.centerline_demo where objectid = 8003;

--Create a binary byte stream of the features and then cast it back out to text
--Ignore the three bad features
select objectid, sde.st_astext(sde.st_geomfromwkb(SDE.ST_ASBINARY(SHAPE), 4326)) from staging.centerline_demo where objectid in (8001,8002,8003);
--Notice no errors

--Query the three bad records
select objectid, sde.st_astext(sde.st_geomfromwkb(SDE.ST_ASBINARY(SHAPE), 4326)) from staging.centerline_demo where objectid not in (8001,8002,8003);
--Notice the error: ORA-20004: Error generating shape from text: Too few points for geometry (-105).

--Notice the binary byte stream is even bad in SDO
CREATE TABLE staging.CENTERLINE_BINARY AS
SELECT SDE.ST_ASBINARY(SHAPE) WKB, Objectid FROM STAGING.CENTERLINE;

select SDO_UTIL.TO_WKTGEOMETRY(SDO_UTIL.FROM_WKBGEOMETRY(wkb)) from staging.centerline_binary where objectid = 8003;

--Try inserting a bad geometry with coincident vertices
insert into staging.centerline_demo (objectid, shape) values (1000000, sde.st_geometry('linestring(-95.465 29.737, -95.465 29.737)', 4326));
--Notice that the sde.st_geometry does not let you do this (Esri is enforcing this, it did not come from Esri)









































































Repro Coincident Vertices:

create table new_centerline (line number(10), route number(10), shape sde.st_geometry, num_pts number(10), pts varchar2(300));

create table old_centerline (line number(10), route number(10), shape sde.st_geometry, num_pts number(10), pts varchar2(300));

CREATE OR REPLACE TRIGGER TRG_INSERT_UPDATE_CENTERLINE
 AFTER UPDATE OF
   LINE,
   ROUTE,
   SHAPE
 ON CENTERLINE FOR EACH ROW
DECLARE
  CHANGE_TYPE CHAR(1);


BEGIN


  IF UPDATING THEN
    CHANGE_TYPE := 'U';
  ELSIF INSERTING THEN
    CHANGE_TYPE := 'I';
  END IF;

  insert into new_centerline(line, route,shape, num_pts,pts)
  select :new.line, :new.route, :new.shape, sde.st_numpoints(:new.shape),sde.st_astext(:new.shape)
  from dual;

  insert into old_centerline(line, route, shape, num_pts, pts)
  select :new.line, :new.route, :old.shape, sde.st_numpoints(:old.shape),sde.st_astext(:old.shape)
  from dual;


END;
/