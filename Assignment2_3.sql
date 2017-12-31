CREATE OR REPLACE 
PACKAGE MY_PACK AS 
PROCEDURE modify_sal(p_departmentID NUMBER);
FUNCTION TOTAL_COST (p_student_id VARCHAR2) RETURN NUMBER;
END MY_PACK;

CREATE OR REPLACE PACKAGE BODY my_pack AS

    PROCEDURE modify_sal (
        p_departmentid NUMBER
    ) IS
        v_salaryavg              NUMBER(20);
        v_updatecount            NUMBER(20) := 0;
        v_salarycalc             NUMBER(20);
        v_validdepartmentvalid   NUMBER(20);
        v_validdepartmentemp     NUMBER(20);
        nodepinemp EXCEPTION;
    BEGIN
        SELECT department_id
        INTO v_validdepartmentvalid
        FROM departments
        WHERE department_id = p_departmentid;
        
        SELECT COUNT(*) 
        INTO v_validdepartmentemp
        FROM employees
        WHERE department_id = p_departmentid;

        IF v_validdepartmentemp = 0 THEN
            RAISE nodepinemp;
        END IF;
        SELECT AVG(salary)
        INTO v_salaryavg
        FROM employees
        WHERE department_id = p_departmentid;

        FOR i IN ( SELECT *
                   FROM employees
                   WHERE department_id = p_departmentid
        FOR UPDATE NOWAIT ) 
        LOOP
            IF i.salary < v_salaryavg THEN
                v_salarycalc := v_salaryavg - i.salary;
                UPDATE employees
                SET salary = v_salaryavg
                WHERE employee_id = i.employee_id;
                v_updatecount := v_updatecount + 1;
                DBMS_OUTPUT.PUT_LINE('Employee ' || i.first_name || ' ' || i.last_name || ' just got an increase of $' || v_salarycalc);
            END IF;
        END LOOP;
        IF v_updatecount > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Total # of employees who received salary increase is: ' || v_updatecount);
        ELSE
            DBMS_OUTPUT.PUT_LINE('No salary was modified in Department: ' || p_departmentid);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('This Department Id is invalid: '
            || p_departmentid);
        WHEN nodepinemp THEN
            DBMS_OUTPUT.PUT_LINE('This Department is EMPTY: '
            || p_departmentid);
    END modify_sal;

FUNCTION TOTAL_COST ( 
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

END my_pack;