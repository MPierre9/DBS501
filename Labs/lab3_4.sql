SET SERVEROUTPUT ON; 
SET VERIFY OFF;

ACCEPT v_zip PROMPT "Enter three digits of zip: ";

DECLARE
v_count NUMBER(5) :=0;
v_recordTotal NUMBER(5);
CURSOR c1 IS SELECT zip, count(student_id) as studentCount from(Select Distinct aa.ZIP, aa.student_id  
             FROM STUDENT aa 
             LEFT JOIN ENROLLMENT bb ON aa.STUDENT_ID = bb.STUDENT_ID 
             WHERE aa.ZIP LIKE '&v_zip'|| '%') 
             GROUP BY ZIP 
             ORDER BY ZIP; 
             
student_rec c1%ROWTYPE;  
       
TYPE student_table_type IS TABLE OF 
student_rec%TYPE INDEX BY PLS_INTEGER;

student_table student_table_type;
   
BEGIN
  Select count(*) INTO v_recordTotal FROM STUDENT WHERE ZIP LIKE '&v_zip'|| '%';
 
  IF v_recordTotal > 0 THEN 
  OPEN c1;
    fetch c1 bulk collect into student_table;
  FOR i IN 1..student_table.count
  LOOP
    DBMS_OUTPUT.PUT_LINE('Zip code: ' || student_table(i).ZIP || ' has exactly ' || student_table(i).studentCount || ' students enrolled.');
    v_count := v_count + 1; 
  END LOOP;
  CLOSE c1;

   DBMS_OUTPUT.PUT_LINE('************************************');
   DBMS_OUTPUT.PUT_LINE('Total # of zip codes under ' || '&v_zip' || ' is ' || v_count);
   DBMS_OUTPUT.PUT_LINE('Total # of Students under zip code ' || '&v_zip' || ' is ' || v_recordTotal);
   ELSE 
   DBMS_OUTPUT.PUT_LINE('This zip area is student empty. Please, try again.');
 END IF;
END;
