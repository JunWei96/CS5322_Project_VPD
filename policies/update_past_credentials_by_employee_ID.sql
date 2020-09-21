create or replace NONEDITIONABLE FUNCTION update_past_credentials_by_employee_ID (v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS 
    condition VARCHAR2(255);
    employee_id int;
    session_user VARCHAR2(30);
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    RETURN 'EXISTS(
            SELECT * FROM EMPLOYEES
            WHERE 1 = 2)';

    RETURN condition;
END update_past_credentials_by_employee_ID;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'past_credentials',
        policy_name => 'update_past_credentials_by_employee_ID_policy',
        policy_function => 'update_past_credentials_by_employee_ID',
        statement_types => 'update');
END;