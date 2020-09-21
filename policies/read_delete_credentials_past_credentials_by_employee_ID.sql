create or replace NONEDITIONABLE FUNCTION read_delete_credentials_past_credentials_by_employee_ID (v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS 
    session_user VARCHAR2(30);
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    RETURN 'EXISTS(
            SELECT * FROM EMPLOYEES
            WHERE 1 = 2)';
END read_delete_credentials_past_credentials_by_employee_ID;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'credentials',
        policy_name => 'read_delete_credentials_by_employee_ID_POLICY',
        policy_function => 'read_delete_credentials_past_credentials_by_employee_ID',
        statement_types => 'select,delete');  
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'past_credentials',
        policy_name => 'read_delete_past_credentials_by_employee_ID_POLICY',
        policy_function => 'read_delete_credentials_past_credentials_by_employee_ID',
        statement_types => 'select,delete');  
END;
/