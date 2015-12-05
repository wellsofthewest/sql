DO 
$$DECLARE 
	pt_curse CURSOR FOR SELECT st_x(geom) as X, st_y(geom) AS Y FROM nyc_subway_stations; 
	x_coord numeric; 
	y_coord numeric;
BEGIN
	OPEN pt_curse;
LOOP
	FETCH pt_curse INTO x_coord, y_coord;
	EXIT WHEN NOT FOUND;
		INSERT INTO myxytable (objectid, x, y, geom)
		SELECT sde.next_rowid('sde', 'myxytable'), 
				x_coord, 
				y_coord, 
				ST_GeomFROMText('POINT(' || cast(x_coord as text)|| ' ' || cast(y_coord as text) || ')''', 4326);

END LOOP;
CLOSE pt_curse;
END$$;

SELECT objectid, x, y, st_astext(geom) from myxytable;