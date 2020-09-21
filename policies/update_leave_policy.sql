CREATE OR REPLACE FUNCTION leaves_by_corporation_groups(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    session_user VARCHAR2(30);
    employee_id NUMBER;
	group_type VARCHAR2(20);
    country_id NUMBER;

BEGIN
       session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
	group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');

    IF (group_type = 'hr' ) THEN
        RETURN 'EXISTS (
            SELECT 1
            FROM EMPLOYEES E
            INNER JOIN CORPORATION_GROUPS CG ON E.CORPORATION_GROUP_ID = CG.ID
            INNER JOIN LOCATIONS L ON L.ID = CG.LOCATION_ID
            WHERE L.COUNTRY_ID = ' || country_id || ' AND leaves.emp_id= E.id)';
    ELSE 
        RETURN 'EXISTS(
            SELECT 1 FROM EMPLOYEES E
            WHERE E.MANAGER_ID = '|| employee_id||' AND e.id = leaves.emp_id)';
    END IF;
   
END leaves_by_corporation_groups;
/

BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'LEAVES',
        policy_name=> 'leaves_by_corporation_groups', 
        policy_function => 'leaves_by_corporation_groups',
        statement_types => 'UPDATE,DELETE,INSERT',
        update_check => TRUE);
END;
