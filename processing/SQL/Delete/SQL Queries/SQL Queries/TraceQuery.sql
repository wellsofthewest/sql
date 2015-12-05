SELECT * 
INTO ExistingDB 
FROM ::fn_trace_gettable('C:\Users\mela6448\Documents\Incidents\1073898_DBList\ExistingDB.trc', default);

SELECT TE.Name, T.* 
FROM  dbo.ExistingDB T -- table that contains the trace results 
JOIN sys.trace_events TE 
ON T.EventClass = TE.trace_event_id

select * from ExistingDB