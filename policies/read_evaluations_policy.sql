CREATE OR REPLACE FUNCTION read_evaluation_by_manager_relationship(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    session_user VARCHAR2(30);
    employee_id NUMBER;
    group_type varchar(20);
    country_id NUMBER;
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');

    IF (group_type = 'hr' ) THEN
        RETURN 'EXISTS (
            SELECT 1
            FROM employees E
            INNER JOIN CORPORATION_GROUPS CG ON CG.ID = E.CORPORATION_GROUP_ID
            INNER JOIN LOCATIONS L ON L.ID = CG.LOCATION_ID
            WHERE L.COUNTRY_ID = ' || country_id ||' AND E.ID = evaluations.recipient)';
    ELSE 
        RETURN 'EXISTS(
            SELECT 1 FROM EMPLOYEES E
            WHERE (E.ID = '|| employee_id ||')AND (evaluations.author = E.ID OR evaluations.recipient = E.ID))';
    END IF;
END read_evaluation_by_manager_relationship;
/

BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'EVALUATIONS',
        policy_name=> 'read_evaluation_by_manager_relationship', 
        policy_function => 'read_evaluation_by_manager_relationship',
        statement_types => 'SELECT');
END;
