SET SERVEROUTPUT ON; 
SET VERIFY OFF; 

ACCEPT v_countryCode PROMPT "Enter value for country";

DECLARE 
v_cCode2 VARCHAR2(2);
v_validCode VARCHAR2(2);
v_streetAddress VARCHAR2(20);
v_city VARCHAR2 (20);
v_stAddrLength NUMBER;
v_stateString VARCHAR(40);
v_locationId NUMBER(8);
v_locationRec LOCATIONS%ROWTYPE;
BEGIN 
    v_cCode2 := '&v_countryCode';
    v_cCode2 := UPPER(v_cCode2);
    SELECT COUNTRY_ID INTO v_validCode FROM COUNTRIES WHERE COUNTRY_ID = v_cCode2;

    SELECT aa.STREET_ADDRESS, aa.CITY, aa.LOCATION_ID INTO v_streetAddress, v_city, v_locationId 
    FROM LOCATIONS aa INNER JOIN COUNTRIES bb ON aa.COUNTRY_ID = bb.COUNTRY_ID
    WHERE aa.COUNTRY_ID = v_cCode2 AND STATE_PROVINCE IS NULL
    GROUP BY aa.STREET_ADDRESS, aa.CITY,aa.LOCATION_ID;
 
    v_stAddrLength := LENGTH(v_streetAddress);
  
    CASE
     WHEN UPPER(v_city) = 'A%' OR UPPER(v_city) LIKE 'B%' OR UPPER(v_city) LIKE 'E%'OR UPPER(v_city) LIKE 'F%' THEN
         FOR i IN 1..v_stAddrLength LOOP
               v_stateString := v_stateString || '*';
         END LOOP;
         UPDATE LOCATIONS SET STATE_PROVINCE = v_stateString WHERE LOCATION_ID = v_locationId;
         DBMS_OUTPUT.PUT_LINE('City ' || v_city || ' has modified its province to ' || v_stateString);


     WHEN UPPER(v_city) LIKE 'C%' OR UPPER(v_city) LIKE 'D%' OR UPPER(v_city) LIKE 'G%'OR UPPER(v_city) LIKE 'H%' THEN
         FOR i IN 1..v_stAddrLength LOOP
               v_stateString := v_stateString || '&';
         END LOOP;                  
         UPDATE LOCATIONS SET STATE_PROVINCE = v_stateString WHERE LOCATION_ID = v_locationId;
         DBMS_OUTPUT.PUT_LINE('City ' || v_city || ' has modified its province to ' || v_stateString);
     ELSE 
         FOR i IN 1..v_stAddrLength LOOP
               v_stateString := v_stateString || '#';
         END LOOP;
         UPDATE LOCATIONS SET STATE_PROVINCE = v_stateString WHERE LOCATION_ID = v_locationId;
         DBMS_OUTPUT.PUT_LINE('City ' || v_city || ' has modified its province to ' || v_stateString);     
    END CASE;
       

    --SELECT * INTO v_locationRec FROM LOCATIONS WHERE LOCATION_ID = v_locationId
ROLLBACK; 
EXCEPTION
 WHEN no_data_found THEN
 DBMS_OUTPUT.PUT_LINE('This country has NO cities listed.');
 WHEN too_many_rows THEN 
 DBMS_OUTPUT.PUT_LINE('This country has MORE THAN ONE City without province listed.'); 
END;
   --rollback;
   --select * from countries where country_id = RS;
   --select * from regions;
   --select * from locations;
 
    
    
