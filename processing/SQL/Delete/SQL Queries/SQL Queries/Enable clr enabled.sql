EXEC sp_configure 'show advanced options' , '1'; 
reconfigure; 

EXEC sp_configure 'clr enabled' , '1' ;
reconfigure; 

EXEC sp_configure 'show advanced options' , '0'; 
reconfigure;