col "Description" format a50
select sid,
        decode(state, 'WAITING','Waiting',
                'Working') state,
        decode(state,
                'WAITING',
                'So far '||seconds_in_wait,
                'Last waited '||
                wait_time/100)||
        ' secs for '||event
        "Description"
from v$session
where username = 'ARUP';