CREATE procedure [dbo].[List_DBRoles]

(

@database nvarchar(128)=null,

@user varchar(20)=null,

@dbo char(1)=null,

@access char(1)=null,

@security char(1)=null,

@ddl char(1)=null,

@datareader char(1)=null,

@datawriter char(1)=null,

@denyread char(1)=null,

@denywrite char(1)=null

)

as

declare @dbname varchar(200)

declare @mSql1 varchar(8000)

CREATE TABLE #DBROLES

( DBName sysname not null,

UserName sysname not null,

db_owner varchar(3) not null,

db_accessadmin varchar(3) not null,

db_securityadmin varchar(3) not null,

db_ddladmin varchar(3) not null,

db_datareader varchar(3) not null,

db_datawriter varchar(3) not null,

db_denydatareader varchar(3) not null,

db_denydatawriter varchar(3) not null,

Cur_Date datetime not null default getdate()

)

 

DECLARE DBName_Cursor CURSOR FOR

select name

from master.dbo.sysdatabases

where name not in ('mssecurity','tempdb')

Order by name

OPEN DBName_Cursor

FETCH NEXT FROM DBName_Cursor INTO @dbname

WHILE @@FETCH_STATUS = 0

BEGIN

Set @mSQL1 = ' Insert into #DBROLES ( DBName, UserName, db_owner, db_accessadmin,

db_securityadmin, db_ddladmin, db_datareader, db_datawriter,

db_denydatareader, db_denydatawriter )

SELECT '+''''+@dbName +''''+ ' as DBName ,UserName, '+char(13)+ '

Max(CASE RoleName WHEN ''db_owner'' THEN ''Yes'' ELSE ''No'' END) AS db_owner,

Max(CASE RoleName WHEN ''db_accessadmin '' THEN ''Yes'' ELSE ''No'' END) AS db_accessadmin ,

Max(CASE RoleName WHEN ''db_securityadmin'' THEN ''Yes'' ELSE ''No'' END) AS db_securityadmin,

Max(CASE RoleName WHEN ''db_ddladmin'' THEN ''Yes'' ELSE ''No'' END) AS db_ddladmin,

Max(CASE RoleName WHEN ''db_datareader'' THEN ''Yes'' ELSE ''No'' END) AS db_datareader,

Max(CASE RoleName WHEN ''db_datawriter'' THEN ''Yes'' ELSE ''No'' END) AS db_datawriter,

Max(CASE RoleName WHEN ''db_denydatareader'' THEN ''Yes'' ELSE ''No'' END) AS db_denydatareader,

Max(CASE RoleName WHEN ''db_denydatawriter'' THEN ''Yes'' ELSE ''No'' END) AS db_denydatawriter

from (

select b.name as USERName, c.name as RoleName

from ' + @dbName+'.dbo.sysmembers a '+char(13)+

' join '+ @dbName+'.dbo.sysusers b '+char(13)+

' on a.memberuid = b.uid join '+@dbName +'.dbo.sysusers c

on a.groupuid = c.uid )s

Group by USERName

order by UserName'

--Print @mSql1

Execute (@mSql1)

FETCH NEXT FROM DBName_Cursor INTO @dbname

END

CLOSE DBName_Cursor

DEALLOCATE DBName_Cursor

Select * from #DBRoles

where ((@database is null) OR (DBName LIKE '%'+@database+'%')) AND

((@user is null) OR (UserName LIKE '%'+@user+'%')) AND

((@dbo is null) OR (db_owner = 'Yes')) AND

((@access is null) OR (db_accessadmin = 'Yes')) AND

((@security is null) OR (db_securityadmin = 'Yes')) AND

((@ddl is null) OR (db_ddladmin = 'Yes')) AND

((@datareader is null) OR (db_datareader = 'Yes')) AND

((@datawriter is null) OR (db_datawriter = 'Yes')) AND

((@denyread is null) OR (db_denydatareader = 'Yes')) AND

((@denywrite is null) OR (db_denydatawriter = 'Yes'))