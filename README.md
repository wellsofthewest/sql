# esri-support-sql-repository
Common SQL scripts for use in an Enterprise Geodatabase (SDE) Environment.

##Conventions

###Folder naming conventions

The folders are named as the script tool with a hyphen between words. All in lowercase font.

e.g. CopyAllOfMyData should look like copy-all-of-my-data

###SQL descriptions

This includes basic information about the script that should be shared so others can get a better idea of what the scipt does and who to refer to when questions arise about the script.

####Example script:
```sql
/***********************************************************************
*
*N  IMPDP.SQL  --  Import Data Pump Steps
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This script serves as a series of steps to complete the import
*	data pump process using the IMPDP utility. This script is meant to
*	be run one step at a time.
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*H  History:
*
*    Christian Wells        11/03/2014               Original coding.
*	 Matt Ziebarth			07/01/2015				 Add Index Functions
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*V  Versions Supported:
*   EGDB: All
*	DBMS: Oracle
*	DBMS Version: 11g and above (Only enter DBMS version if it requires a specific version)
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*T  Tags:
*   IMPDP, Data Pump, Oracle, Import   
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*R  Resources:
*   IMPDP Syntax:	
*	http://ss64.com/ora/impdp.html 
*E
***********************************************************************/
```
