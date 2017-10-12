SET SERVEROUTPUT ON; 
SET VERIFY OFF;

DECLARE 
TYPE course_table_type IS TABLE OF 
COURSE%ROWTYPE ;

course_table course_table_type := course_table_type();

v_recCount NUMBER(10);
CURSOR c1 IS SELECT * FROM COURSE WHERE PREREQUISITE IS NULL ORDER BY DESCRIPTION;

BEGIN 

OPEN c1;
  
fetch c1 bulk collect into course_table;

FOR i IN 1..course_table.count
  LOOP
     v_recCount := i;
     course_table.EXTEND;
     DBMS_OUTPUT.PUT_LINE('Course Description: ' || i || ': ' || course_table(i).DESCRIPTION);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('************************************');
  DBMS_OUTPUT.PUT_LINE('Total # of Courses without the Prerequisite is: ' || v_recCount);
CLOSE c1;
END;
