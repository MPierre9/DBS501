SET SERVEROUTPUT ON
SET VERIFY OFF

--Silently checks if the 'flag colum exists'
--If not it will create it
DECLARE
  column_exists EXCEPTION;
  PRAGMA exception_init (column_exists , -01430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE countries ADD flag CHAR(7)';
EXCEPTION
WHEN column_exists THEN
  NULL;
END;
/

ACCEPT tmp_regionID PROMPT 'Enter value for region';
DECLARE
  v_regionID regions.region_id%TYPE := '&tmp_regionID';
  v_countryName countries.country_name%TYPE;
  v_loop_counter BINARY_INTEGER := 0;
  v_flag countries.flag%TYPE;
  CURSOR c_empty_cursor
  IS
    SELECT c.country_name
    FROM countries c
    LEFT JOIN locations l
    ON c.country_id = l.country_id
    WHERE l.city   IS NULL
    AND c.region_id = v_regionID
    GROUP BY c.country_name ;
BEGIN
  SELECT r.region_id
  INTO v_regionID
  FROM regions r
  WHERE r.region_id = v_regionID;
  OPEN c_empty_cursor;
  LOOP
    FETCH c_empty_cursor
    INTO v_countryName;
    v_loop_counter := c_empty_cursor%ROWCOUNT;
    EXIT
  WHEN c_empty_cursor%NOTFOUND;
  END LOOP;
  CLOSE c_empty_cursor;
  IF v_loop_counter = 1 THEN
    DBMS_OUTPUT.PUT_LINE('In the region ' || v_regionID || ' there is one country ' || v_countryName || ' with NO city.');
    v_loop_counter := 0;
    FOR curse IN
    (SELECT c.country_id,
      c.country_name,
      c.region_id,
      c.flag
    FROM countries c
    LEFT JOIN locations l
    ON c.country_id = l.country_id
    WHERE l.city   IS NULL
    GROUP BY c.country_id,
      c.region_id,
      c.country_name,
      c.flag
    )
    LOOP
      v_flag :='Empty_' || curse.region_id ;
      UPDATE countries SET flag = v_flag WHERE country_id = curse.country_id;
      v_loop_counter := v_loop_counter + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Number of countries with NO cities listed is: ' || v_loop_counter);
  END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE('This region ID does NOT exist: ' || v_regionID);
WHEN too_many_rows THEN
  DBMS_OUTPUT.PUT_LINE('This region has more than one country with and empty location.');
  DBMS_OUTPUT.PUT_LINE('no rows selected');
END;
       /
SELECT *
FROM countries c
WHERE flag IS NOT NULL
ORDER BY c.region_id,
  c.country_name,
  c.flag ASC;
ROLLBACK;
