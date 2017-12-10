CREATE OR REPLACE PROCEDURE modify_sal(p_departmentID NUMBER) IS
v_salaryAvg NUMBER(20);
v_updateCount NUMBER(20) :=0;
v_salaryCalc NUMBER(20);
v_validDepartmentValid NUMBER(20);
v_validDepartmentEmp NUMBER(20);
noDepInEmp EXCEPTION;
BEGIN
 
  SELECT DEPARTMENT_ID INTO v_validDepartmentValid FROM DEPARTMENTS WHERE DEPARTMENT_ID = p_departmentID; 
  SELECT COUNT(*) INTO v_validDepartmentEmp FROM EMPLOYEES WHERE DEPARTMENT_ID = p_departmentID;
 
  IF v_validDepartmentEmp = 0 THEN 
   RAISE noDepInEmp;
  END IF;
 
  SELECT AVG(SALARY) INTO v_salaryAvg FROM EMPLOYEES WHERE DEPARTMENT_ID = p_departmentID;

  FOR i IN (SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = p_departmentID FOR UPDATE NOWAIT)
  LOOP
      IF i.SALARY < v_salaryAvg THEN 
        v_salaryCalc := v_salaryAvg - i.SALARY;
        UPDATE EMPLOYEES SET SALARY = v_salaryAvg WHERE EMPLOYEE_ID = i.EMPLOYEE_ID;
        v_updateCount := v_updateCount + 1; 
        DBMS_OUTPUT.PUT_LINE('Employee ' || i.FIRST_NAME || ' ' || i.LAST_NAME || ' just got an increase of $' || v_salaryCalc);
      END IF;  
  END LOOP;
   
  IF v_updateCount > 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Total # of employees who received salary increase is: ' || v_updateCount);
  ELSE
    DBMS_OUTPUT.PUT_LINE('No salary was modified in Department: ' || p_departmentID);
  END IF;
  COMMIT;
  
  EXCEPTION 
  WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE('This Department Id is invalid: ' || p_departmentId);
   
  WHEN noDepInEmp THEN
       DBMS_OUTPUT.PUT_LINE('This Department is EMPTY: ' || p_departmentId);
   
END modify_sal;
