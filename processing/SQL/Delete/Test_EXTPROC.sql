
set timing on
set autotrace on


PROMPT
PROMPT ==========================
PROMPT = SDE.ST_GEOMETRY(POINT) =
PROMPT ==========================
PROMPT

PROMPT SELECT SDE.ST_GEOMETRY('POINT(10 10)', 0) FROM dual;

SELECT SDE.ST_GEOMETRY('POINT(10 10)', 0) FROM dual;

PROMPT
PROMPT =======================
PROMPT = SDE.ST_POINT(0,0,0) =
PROMPT =======================
PROMPT

PROMPT SELECT SDE.ST_POINT(0,0,0) FROM dual;

SELECT SDE.ST_POINT(0,0,0) FROM dual;


PROMPT
PROMPT =================
PROMPT = SDE.ST_ASTEXT =
PROMPT =================
PROMPT

PROMPT SELECT SDE.ST_ASTEXT(a.SHAPE) FROM SDE.GDB_ITEMS a WHERE ROWNUM < 5;

SELECT SDE.ST_ASTEXT(a.SHAPE) FROM SDE.GDB_ITEMS a WHERE ROWNUM < 5;


PROMPT
PROMPT ====================
PROMPT = SDE.GDB_ITEMS_VW =
PROMPT ====================
PROMPT

PROMPT SELECT * FROM SDE.GDB_ITEMS_VW where objectid < 5;

SELECT * FROM SDE.GDB_ITEMS_VW where objectid < 5;



PROMPT
PROMPT

set autotrace off

set timing off


