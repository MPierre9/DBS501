SET SERVEROUTPUT ON; 
SET VERIFY OFF;

ACCEPT v_zip PROMPT "Enter three digits of zip: ";

DECLARE
TYPE T_REC IS RECORD
(ZIP_CODE NUMBER, enrollCount NUMBER);

course_rec T_REC;
v_count NUMBER(5) :=0;
v_recordTotal NUMBER(5);
CURSOR c1 IS SELECT zip, count(student_id) from(Select Distinct aa.ZIP, aa.student_id  
             FROM STUDENT aa 
             LEFT JOIN ENROLLMENT bb ON aa.STUDENT_ID = bb.STUDENT_ID 
             WHERE aa.ZIP LIKE '&v_zip'|| '%') 
             GROUP BY ZIP 
             ORDER BY ZIP; 
   
BEGIN
  Select count(*) INTO v_recordTotal FROM STUDENT WHERE ZIP LIKE '&v_zip'|| '%';   
  IF v_recordTotal > 0 THEN 
  OPEN c1;
  LOOP
    FETCH c1 INTO course_rec;
    EXIT  WHEN  c1%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Zip code: ' || course_rec.zip_code || ' has exactly ' || course_rec.enrollCount || ' students enrolled.');
    v_count := v_count + 1; 
  END LOOP;
   DBMS_OUTPUT.PUT_LINE('************************************');
   DBMS_OUTPUT.PUT_LINE('Total # of zip codes under ' || '&v_zip' || ' is ' || v_count);
   DBMS_OUTPUT.PUT_LINE('Total # of Students under zip code ' || '&v_zip' || ' is ' || v_recordTotal); 
   ELSE 
    DBMS_OUTPUT.PUT_LINE('This zip area is student empty. Please, try again.');
   END IF;
END;
