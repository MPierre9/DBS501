SET SERVEROUTPUT ON; 
SET VERIFY OFF;

ACCEPT v_courseSearch PROMPT "Enter the piece of the course description in UPPER case:";
ACCEPT v_instrSearch PROMPT "Enter the piece of the course description in UPPER case:";

DECLARE 
  CURSOR c1 IS 
  SELECT aa.COURSE_NO, aa.DESCRIPTION, bb.SECTION_ID, cc.LAST_NAME, bb.SECTION_NO 
  FROM COURSE aa 
  INNER JOIN SECTION bb ON  aa.COURSE_NO = bb.COURSE_NO
  INNER JOIN INSTRUCTOR cc ON cc.INSTRUCTOR_ID = bb.INSTRUCTOR_ID where UPPER(aa.description) LIKE '%'||'&v_courseSearch'||'%' AND UPPER(cc.LAST_NAME) LIKE '&v_instrSearch'||'%';
  CURSOR c2 (sec_id NUMBER) IS 
  SELECT count(student_id) as studentCount FROM ENROLLMENT WHERE SECTION_ID = sec_id;
  v_isRecords NUMBER := 0;
  v_enrollmentCount NUMBER := 0;
BEGIN 
  FOR i IN c1
    LOOP 
     EXIT  WHEN  c1%NOTFOUND;
     v_isRecords := 1;
     DBMS_OUTPUT.PUT_LINE('Course No: ' || i.COURSE_NO || ' ' || i.DESCRIPTION || ' with Section Id: ' || i.SECTION_ID || ' is taught by ' || i.LAST_NAME || ' in the Course Section: ' || i.SECTION_NO);
     FOR j IN c2(i.section_id)
       LOOP
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('This Section Id has an enrollment of: ' || j.studentCount);
        v_enrollmentCount := v_enrollmentCount + j.studentCount; 
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('*********************************************************************');
   END LOOP;
   IF v_isRecords = 0 THEN
     DBMS_OUTPUT.PUT_LINE('There is NO data for this input match between the course description piece and the surname start of Instructor. Try again!');
   ELSE
     DBMS_OUTPUT.PUT_LINE('This input match has a total enrollment of: ' || v_enrollmentCount || ' students.');
   END IF;
END;

