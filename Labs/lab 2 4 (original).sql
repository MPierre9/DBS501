SET SERVEROUTPUT ON; 
SET VERIFY OFF;

ACCEPT v_locId PROMPT "Enter valid Location Id: ";

DECLARE
v_locId2 NUMBER;
v_depId NUMBER;
v_depCount NUMBER;
v_empCount NUMBER;
v_c1 NUMBER := 1;
v_c2 NUMBER := 1;
v_temp NUMBER;
BEGIN 

    v_locId2 := &v_locId;
   
    UPDATE  Departments
    SET     location_id = 1400
    WHERE  department_id IN (40,70);
 
    SELECT COUNT(department_id) INTO v_depCount FROM departments WHERE location_id = v_locId2;
    SELECT COUNT(employee_id) INTO v_temp FROM employees aa INNER JOIN DEPARTMENTS bb ON aa.DEPARTMENT_ID = bb.DEPARTMENT_ID WHERE location_id = v_locId2;

    FOR i IN 1..v_depCount LOOP       
     
      v_c2 := 1;
      DBMS_OUTPUT.PUT_LINE('Outer Loop: Department #' || v_c1);
        
        FOR I IN 1..v_temp LOOP

           DBMS_OUTPUT.PUT_LINE('* Inner Loop: Employee #' || v_c2);
           v_c2 := v_c2 + 1;
           
       END LOOP;
      
       v_c1 := v_c1 + 1;
    END LOOP;
   
    DBMS_OUTPUT.PUT_LINE('PL/SQL procedure successfully completed.');

    ROLLBACK; 
    DBMS_OUTPUT.PUT_LINE('Rollback complete.');
END;
