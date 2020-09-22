CREATE OR REPLACE FUNCTION update_evaluation_by_manager_relationship(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    session_user VARCHAR2(30);
    employee_id NUMBER;

BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');

    RETURN 'EXISTS(
            SELECT 1 FROM EMPLOYEES E
            WHERE E.MANAGER_ID = '|| employee_id ||' E.id = evaluations.recipient)';

END update_evaluation_by_manager_relationship;
/

BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'EVALUATIONS',
        policy_name=> 'update_evaluation_by_manager_relationship', 
        policy_function => 'update_evaluation_by_manager_relationship',
        statement_types => 'UPDATE, INSERT',
        update_check => TRUE);
END;