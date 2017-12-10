SET  SERVEROUTPUT  ON
SET  VERIFY OFF
ACCEPT P_REGID  PROMPT  'Enter value for region:  '
DECLARE
  CURSOR C1 IS  SELECT C.* FROM COUNTRIES C
 WHERE C.REGION_ID = &P_REGID AND C.COUNTRY_ID NOT IN (SELECT COUNTRY_ID FROM LOCATIONS );
  CURSOR C2 IS  SELECT C.* FROM COUNTRIES C
 WHERE C.COUNTRY_ID NOT IN (SELECT COUNTRY_ID FROM LOCATIONS ) ORDER BY C.COUNTRY_NAME;
 FI INT := 0;
 COUNTER INT := -4;
 TOTAL INT := 0;
 COUNTRY_NAME1 VARCHAR2(100);
 COUNTRY_NAME2 VARCHAR2(100);
BEGIN
  SELECT COUNT(*) INTO FI FROM REGIONS WHERE REGION_ID = &P_REGID;
  IF FI = 0 THEN
    DBMS_OUTPUT.PUT_LINE('This region ID does NOT exist: ' || &P_REGID);
  ELSE
    --DBMS_OUTPUT.PUT_LINE('This region ID does exist: ' || &P_REGID);
    FOR I IN C2 LOOP
      UPDATE COUNTRIES SET FLAG = ('Empty_' || TO_CHAR(I.REGION_ID)) WHERE COUNTRY_ID = I.COUNTRY_ID;
      COUNTER := COUNTER + 5;
      TOTAL := TOTAL +1;
      DBMS_OUTPUT.PUT_LINE('Index Table Key: ' || COUNTER || ' has a value of ' || I.COUNTRY_NAME);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('======================================================================');
    SELECT COUNTRY_NAME INTO COUNTRY_NAME1 FROM(
SELECT F.*,ROWNUM rnum FROM (SELECT C.* FROM COUNTRIES C
 WHERE C.COUNTRY_ID NOT IN (SELECT COUNTRY_ID FROM LOCATIONS ) ORDER BY C.COUNTRY_NAME ) F
 ) A WHERE A.RNUM = 2;

    SELECT COUNTRY_NAME INTO COUNTRY_NAME2 FROM(
SELECT F.*,ROWNUM rnum FROM (SELECT C.* FROM COUNTRIES C
 WHERE C.COUNTRY_ID NOT IN (SELECT COUNTRY_ID FROM LOCATIONS ) ORDER BY C.COUNTRY_NAME ) F
 ) A WHERE A.RNUM = (TOTAL - 1);
    DBMS_OUTPUT.PUT_LINE('Total number of elements in the Index Table or Number of countries with NO cities listed is:' || TOTAL);
    DBMS_OUTPUT.PUT_LINE('Second element (Country) in the Index Table is: ' || COUNTRY_NAME1);
    DBMS_OUTPUT.PUT_LINE('Before the last element (Country) in the Index Table is:' || COUNTRY_NAME2);
    DBMS_OUTPUT.PUT_LINE('======================================================================');
    COUNTER := 0;
    FOR K IN C1 LOOP
      COUNTER := COUNTER + 1;
      DBMS_OUTPUT.PUT_LINE('In the region '|| &P_REGID ||' there is country ' || K.COUNTRY_NAME || ' with NO city.');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('======================================================================');
    DBMS_OUTPUT.PUT_LINE('Total Number of countries with NO cities listed in the Region 1 is: ' || COUNTER );
    
    DBMS_OUTPUT.PUT_LINE('CO COUNTRY_NAME                              REGION_ID FLAG   ' );
    DBMS_OUTPUT.PUT_LINE('-- ---------------------------------------- ---------- -------' );
    FOR J IN (SELECT C.* FROM COUNTRIES C
 WHERE C.COUNTRY_ID NOT IN (SELECT COUNTRY_ID FROM LOCATIONS ) ORDER BY  C.REGION_ID ,C.COUNTRY_NAME) LOOP
      DBMS_OUTPUT.PUT_LINE(J.COUNTRY_ID || '  ' || J.COUNTRY_NAME || ' ' || J.REGION_ID || '  ' || J.FLAG);

    END LOOP;

  END IF;
  ROLLBACK;
END;
