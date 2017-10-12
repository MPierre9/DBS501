SET SERVEROUTPUT ON; 
SET VERIFY OFF;

DECLARE 
TYPE course_table_type IS TABLE OF 
COURSE.DESCRIPTION%TYPE INDEX BY PLS_INTEGER;
course_table course_table_type ;
v_recCount NUMBER(10) := 1;
CURSOR c1 IS SELECT DESCRIPTION FROM COURSE WHERE PREREQUISITE IS NULL ORDER BY DESCRIPTION;

BEGIN 

OPEN c1;
  LOOP
     fetch c1 into course_table(v_recCount);
     EXIT  WHEN  c1%NOTFOUND;
     DBMS_OUTPUT.PUT_LINE('Course Description: ' || v_recCount || ': ' || course_table(v_recCount));
     v_recCount := v_recCount +1;
  END LOOP;
  v_recCount := v_recCount -1;
  DBMS_OUTPUT.PUT_LINE('************************************');
  DBMS_OUTPUT.PUT_LINE('Total # of Courses without the Prerequisite is: ' || v_recCount);
CLOSE c1;
END;
