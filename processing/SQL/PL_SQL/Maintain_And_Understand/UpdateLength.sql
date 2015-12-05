SET SERVEROUTPUT ON
-- Declare a cursor
DECLARE
  CURSOR points
  IS
    SELECT GLOBALID, SHAPE, STATE FROM SDE.FC;
  --Loop through the cursor
BEGIN
  FOR pt IN points
  LOOP
    IF pt.STATE IN ('CO', 'NE', 'WY') THEN
      UPDATE SDE.FC
      SET st_length_ft = sde.st_length(sde.st_transform(PT.shape, 26913)) * 3.28084
      WHERE GLOBALID   = PT.GLOBALID;
    ELSIF pt.STATE     = 'AR' THEN
      UPDATE SDE.FC
      SET st_length_ft = sde.st_length(sde.st_transform(PT.shape, 3433))
      WHERE GLOBALID   = PT.GLOBALID;
    ELSE
      DBMS_OUTPUT.PUT_LINE('No State found for GID: ' || pt.GLOBALID);
    END IF;
  END LOOP;
  COMMIT;
END;
/
