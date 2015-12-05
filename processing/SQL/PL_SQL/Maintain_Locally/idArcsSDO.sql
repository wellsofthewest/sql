 CREATE FUNCTION isCompoundElement(p_elem_type IN NUMBER)
    RETURN BOOLEAN
  IS
  BEGIN
    RETURN ( p_elem_type IN (4,5,1005,2005) );
  END ISCOMPOUNDELEMENT;
  /

  CREATE FUNCTION hasCircularArcs(p_elem_info IN mdsys.sdo_elem_info_array)
    RETURN BOOLEAN
  IS
     v_elements  NUMBER;
  BEGIN
     v_elements := ( ( p_elem_info.COUNT / 3 ) - 1 );
     <<element_extraction>>
     FOR v_i IN 0 .. v_elements LOOP
        IF ( ( /* etype */         p_elem_info(v_i * 3 + 2) = 2 AND
               /* interpretation*/ p_elem_info(v_i * 3 + 3) = 2 )
             OR
             ( /* etype */         p_elem_info(v_i * 3 + 2) IN (1003,2003) AND
               /* interpretation*/ p_elem_info(v_i * 3 + 3) IN (2,4) ) ) THEN
               RETURN TRUE;
        END IF;
     END loop element_extraction;
     RETURN FALSE;
  END HASCIRCULARARCS;
/

  CREATE FUNCTION isCompound(p_elem_info IN mdsys.sdo_elem_info_array)
    RETURN INTEGER
  IS
  BEGIN
    RETURN CASE WHEN hasCircularArcs(p_elem_info) THEN 1 ELSE 0 END;
  END ISCOMPOUND;
/
  create FUNCTION hasArc(p_elem_info IN mdsys.sdo_elem_info_array)
    RETURN INTEGER
  IS
  BEGIN
    RETURN CASE WHEN HASCIRCULARARCS(P_ELEM_INFO) THEN 1 ELSE 0 END;
  END HASARC;
 / 
  
  SELECT 
  A.PRESSURE_ZONE_ID,
       sjpw.hasArc(a.GDO_GEOMETRY_ORIG.sdo_elem_info) AS hasArc,
       GDO_GEOMETRY_ORIG
  FROM   SJPW.PRESSURE_ZONE A
   where gdo_geometry_orig is not null
  order by 2 desc;