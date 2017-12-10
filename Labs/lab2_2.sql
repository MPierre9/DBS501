SET SERVEROUTPUT ON;

ACCEPT v_instrId NUMBER FORMAT 999 PROMPT "Please enter the Instructor Id: ";

DECLARE 

v_instrId2 NUMBER;
v_found NUMBER;
v_instrFullName VARCHAR2(20);
v_classesTaught VARCHAR2 (20);
v_valid NUMBER;
e_invalid_instructor EXCEPTION;
BEGIN 

    v_instrId2 := &v_instrId;
    SELECT count(*) into v_valid FROM INSTRUCTOR WHERE INSTRUCTOR_ID = v_instrId2;
    IF v_valid = 0 THEN
      RAISE e_invalid_instructor; 
    END IF;
    
    
    SELECT CONCAT(CONCAT(first_name, ' '),last_name) "Full Name", count(aa.INSTRUCTOR_ID) as CLASSES_TAUGHT 
    INTO v_instrFullName, v_classesTaught FROM INSTRUCTOR aa 
    INNER JOIN SECTION bb ON aa.INSTRUCTOR_ID = bb.INSTRUCTOR_ID 
    WHERE aa.INSTRUCTOR_ID = v_instrId2
    GROUP BY FIRST_NAME, LAST_NAME;
    
    IF SQL%NOTFOUND THEN
      RAISE e_invalid_instructor; 
    END IF;
    
    CASE 
       WHEN v_classesTaught = 10 THEN DBMS_OUTPUT.PUT_LINE('Instructor, ' || v_instrFullName || ', teaches ' || v_classesTaught || ' section(s).');
                                      DBMS_OUTPUT.PUT_LINE('This instructor needs to rest in the next term.');
                                      DBMS_OUTPUT.PUT_LINE('PL/SQL procedure successfully completed.');
  
       WHEN v_classesTaught < 10 AND v_classesTaught > 2 THEN DBMS_OUTPUT.PUT_LINE('Instructor, ' || v_instrFullName || ', teaches ' || v_classesTaught || ' section(s).');
                                                              DBMS_OUTPUT.PUT_LINE('This instructor teaches enough sections. ');
                                                              DBMS_OUTPUT.PUT_LINE('PL/SQL procedure successfully completed.');
                                                              
       WHEN v_classesTaught > 1  AND v_classesTaught < 3 THEN DBMS_OUTPUT.PUT_LINE('Instructor, ' || v_instrFullName || ', teaches ' || v_classesTaught || ' section(s).');
                                                              DBMS_OUTPUT.PUT_LINE('This instructor could teach a bit more.');
                                                              DBMS_OUTPUT.PUT_LINE('PL/SQL procedure successfully completed.');
                                                              
                                                              
   
 
                                                              
    END CASE;
      
  EXCEPTION 
    WHEN e_invalid_instructor THEN   
      DBMS_OUTPUT.PUT_LINE('This is not a valid instructor');
      
    WHEN NO_DATA_FOUND THEN
       
          SELECT CONCAT(CONCAT(first_name, ' '),last_name) "Full Name" INTO v_instrFullName FROM INSTRUCTOR WHERE INSTRUCTOR_ID = v_instrId2;

          DBMS_OUTPUT.PUT_LINE('Instructor, ' || v_instrFullName || ', teaches 0 section(s).');
          DBMS_OUTPUT.PUT_LINE('This instrutctor may teach more sections.');
          DBMS_OUTPUT.PUT_LINE('PL/SQL procedure successfully completed.');
END;
--select * from instructor


