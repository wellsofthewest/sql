
set lines 240
set serverout on size 1000000
 
DECLARE 

    v_commit_cnt    pls_integer := 0; 
    v_count             pls_integer := 0;
    v_point_cnt       pls_integer; 
    
    v_geo_srid      pls_integer; 
    v_seq_name    VARCHAR2(100); 
    v_sql_block    VARCHAR2(1000);
    v_object_id    number(38);
        
    v_prev_well     NUMBER := 0; 
    v_shp_clob      CLOB;
    v_erase_amt     INTEGER; 
 
    cursor v_well_pt_cursor is
        SELECT distinct p.division, p.uwi, p.primo_prprty, p.point_x, p.point_y, p.surv_md_dpth as MD, 
           -1 * abs (case when p.surv_tvd_dpth = 0 then p.surv_md_dpth else p.surv_tvd_dpth end) as point_Z 
            FROM well.us_full_survey_pts_nad27 p
            WHERE p.division is not null and p.primo_prprty is not null and 
                p.point_x is not null and p.point_y is not null
                and p.primo_prprty = 66390/*66376*/ and mod(p.surv_md_dpth, 1) = 0 
            ORDER BY p.division, p.primo_prprty, p.surv_md_dpth desc; 
            
BEGIN 

    DBMS_OUTPUT.PUT_LINE('---');
    DBMS_OUTPUT.PUT     (TO_CHAR(SYSDATE, 'MM/DD/YYYY HH:MI AM')||'   ');
    DBMS_OUTPUT.PUT_LINE('create_survey_well_paths Start Time.');
    
    -- determine the sequence 
    select SUBSTR(index_name, 0, INSTR(index_name, '_')-1) into v_seq_name
    from all_indexes 
    where table_name = 'CAN_WELL_PATH_TEST' and index_name like '%_SDE_ROWID_UK';     
    --DBMS_OUTPUT.PUT_LINE('v_seq_name: ' || v_seq_name); 
    
    -- determine the SRID 
    select srid into v_geo_srid 
    from sde.st_geometry_columns
    where table_name = 'CAN_WELL_PATH_TEST';    
    --DBMS_OUTPUT.PUT_LINE('v_geo_srid: ' || v_geo_srid);
    
    FOR well_pt IN v_well_pt_cursor LOOP 
    
            if  v_prev_well <> well_pt.PRIMO_PRPRTY then
            
                if v_prev_well <> 0 then
                
                    if v_point_cnt < 2 then
                        DBMS_OUTPUT.PUT_LINE('Well ID: ' || v_prev_well || '  discarded for fewer than 2 points');
                    else
                
                        --DBMS_OUTPUT.PUT_LINE('closing LINESTRING'); 
                        DBMS_LOB.APPEND(v_shp_clob, to_clob(')'));
                    
                        v_sql_block := 'SELECT ' || v_seq_name || '.nextval from dual '; 
                        execute immediate v_sql_block into v_object_id; 
                    
                        -- insert into the well path table 
                        BEGIN
                            --DBMS_OUTPUT.PUT_LINE('insert a line feature: ' || to_char(v_shp_clob));
                            INSERT INTO WELL.CAN_WELL_PATH_TEST 
                                (OBJECTID, UWI, GLOBALID, SURVEY_ID, SHAPE)
                            values
                                (v_object_id, to_char(v_object_id), to_char(v_object_id), v_prev_well, sde.st_linefromtext(v_shp_clob, v_geo_srid));  
                            
                            v_commit_cnt := v_commit_cnt + 1; 
                            v_count := v_count + 1; 
                                
                            if v_commit_cnt = 1000 then 
                                commit; 
                                DBMS_OUTPUT.PUT_LINE('committed at ' || to_char(v_count)); 
                                
                                v_commit_cnt := 0; 
                            end if;
                            
                        EXCEPTION

                            WHEN OTHERS THEN
                                DBMS_OUTPUT.PUT     ('Well ID: ' || v_prev_well || '(' || to_char(v_point_cnt) || ') ');
                                DBMS_OUTPUT.PUT_LINE('  Error Message: '|| SQLERRM);
                                
                        END;
                            
                    end if;
                     
                end if; 
                
                v_prev_well := well_pt.PRIMO_PRPRTY;
                --DBMS_OUTPUT.PUT_LINE('well id: ' || to_char(v_prev_well)); 
            
                --DBMS_OUTPUT.PUT_LINE('initialize for next well'); 
                select 'LINESTRING ZM (' into v_shp_clob from dual;
                v_point_cnt := 0; 
                
            end if;   
    
            v_point_cnt := v_point_cnt + 1;  
    
            if v_point_cnt > 1 then 
                DBMS_LOB.APPEND(v_shp_clob, to_clob(','));
            end if;
                
            --DBMS_OUTPUT.PUT_LINE('append point to a line');
            DBMS_LOB.APPEND(v_shp_clob, to_clob( to_char(well_pt.POINT_X) || ' ' || to_char(well_pt.POINT_Y) || ' ' || to_char(well_pt.POINT_Z) || ' ' || to_char(well_pt.MD)) );
            
            EXIT WHEN v_point_cnt > 220; 
                            
    END LOOP;    
        
    --DBMS_OUTPUT.PUT_LINE('closing LINESTRING'); 
    DBMS_LOB.APPEND(v_shp_clob, to_clob(')')); 
                            
    v_sql_block := 'SELECT ' || v_seq_name || '.nextval from dual '; 
    execute immediate v_sql_block into v_object_id; 
            
    -- insert into the well path table 
    DBMS_OUTPUT.PUT_LINE('insert a line feature: ' || to_char(v_shp_clob));
    INSERT INTO WELL.CAN_WELL_PATH_TEST 
        (OBJECTID, UWI, GLOBALID, SURVEY_ID, SHAPE)
    values
        (v_object_id, to_char(v_object_id), to_char(v_object_id), v_prev_well, sde.st_linefromtext(v_shp_clob, v_geo_srid));  
    
    v_count := v_count + 1; 

    commit; 
    DBMS_OUTPUT.PUT_LINE('committed at ' || to_char(v_count)); 
    
    DBMS_OUTPUT.PUT_LINE('  point cnt: '|| to_char(v_point_cnt));
    DBMS_OUTPUT.PUT_LINE('  CLOB char cnt: '|| to_char(DBMS_LOB.GETLENGTH(v_shp_clob)));    

    DBMS_LOB.FREETEMPORARY(v_shp_clob);    

    DBMS_OUTPUT.PUT     (TO_CHAR(SYSDATE, 'MM/DD/YYYY HH:MI AM')||'   ');
    DBMS_OUTPUT.PUT_LINE('   create_survey_well_paths End Time.' );
    DBMS_OUTPUT.PUT_LINE('---');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT     (TO_CHAR(SYSDATE, 'MM/DD/YYYY HH:MI AM')||'   ');
        DBMS_OUTPUT.PUT     (' Well ID: ' || v_prev_well);
        DBMS_OUTPUT.PUT_LINE('  point cnt: '|| to_char(v_point_cnt));
        DBMS_OUTPUT.PUT_LINE('  CLOB char cnt: '|| to_char(DBMS_LOB.GETLENGTH(v_shp_clob)));    
        DBMS_OUTPUT.PUT_LINE('  Error Message: '|| SQLERRM);
        
END; 
            