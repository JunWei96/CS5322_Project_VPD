CREATE OR REPLACE FUNCTION leaves_by_corporation_groups(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    condition VARCHAR2(255);
    session_user VARCHAR2(30);
    employee_id NUMBER;
	group_type VARCHAR2(20);
    country_id NUMBER;
    is_manager int;
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');
    is_manager := SYS_CONTEXT('EMPLOYEE_MGMT', 'IS_MANAGER');

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
    ELSIF (is_manager = 1) THEN
        return 'leaves.emp_id = ' || employee_id || ' OR EXISTS(
            SELECT 1 FROM EMPLOYEES E
            WHERE E.MANAGER_ID = '|| employee_id||' AND e.id = leaves.emp_id)';
    ELSE
        return '1=0';
    END IF;
END leaves_by_corporation_groups;
/
CREATE OR REPLACE FUNCTION update_self_leaves(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    condition VARCHAR2(255);
    session_user VARCHAR2(30);
    employee_id NUMBER;
	group_type VARCHAR2(20);
    country_id NUMBER;
    is_manager INT;
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');
    is_manager := SYS_CONTEXT('EMPLOYEE_MGMT', 'IS_MANAGER');


    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
	group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');

    IF (group_type = 'hr' OR is_manager = 1) THEN
        RETURN '';
    ELSE 
        return 'leaves.emp_id = ' || employee_id;
    END IF;
END update_self_leaves;
/
BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'LEAVES',
        policy_name=> 'leaves_by_corporation_groups', 
        policy_function => 'leaves_by_corporation_groups',
        statement_types => 'UPDATE,DELETE,INSERT',
        update_check => TRUE);
END;
/
BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'LEAVES',
        policy_name=> 'update_self_leaves_policy', 
        policy_function => 'update_self_leaves',
        statement_types => 'UPDATE',
        update_check => TRUE);
END;
