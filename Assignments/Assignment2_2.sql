CREATE OR REPLACE FUNCTION TOTAL_COST ( 
p_student_id IN VARCHAR2) 
RETURN NUMBER IS v_total_cost NUMBER;

v_student_id NUMBER;
v_enrolled_courses NUMBER;
e_not_enrolled EXCEPTION;

BEGIN
SELECT student_id INTO v_student_id
FROM student
WHERE student_id = p_student_id;

SELECT COUNT(student_id)INTO v_enrolled_courses
FROM enrollment
WHERE student_id = p_student_id;

IF v_enrolled_courses = 0 THEN 
RAISE e_not_enrolled;
ELSE
SELECT SUM(C.COST) AS INTO v_total_cost
FROM enrollment E
INNER JOIN section S ON E.section_id = S.section_id
INNER JOIN course C ON S.course_no = C.course_no
WHERE E.student_id = p_student_id
GROUP BY E.student_id;

RETURN v_total_cost;
END IF;

EXCEPTION 
WHEN e_not_enrolled THEN RETURN 0;
WHEN no_data_found THEN RETURN -1;
END total_cost;

/
