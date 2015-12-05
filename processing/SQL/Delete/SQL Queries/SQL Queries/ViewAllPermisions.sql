select USER_NAME(p.grantee_principal_id) AS principal_name,
        dp.type_desc AS principal_type_desc,
        p.class_desc,
        OBJECT_NAME(p.major_id) AS object_name,
        p.permission_name,
        p.state_desc AS permission_state_desc
from    sys.database_permissions p
inner   JOIN sys.database_principals dp
on     p.grantee_principal_id = dp.principal_id