create or replace NONEDITIONABLE FUNCTION read_credentials_past_credentials_by_employee_ID (v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS 
    session_user VARCHAR2(30);
    employee_id int;
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    ELSE
        RETURN 'employee_id = ' || employee_id;
    END IF;
END read_credentials_past_credentials_by_employee_ID;
/
create or replace NONEDITIONABLE FUNCTION delete_credentials_past_credentials_by_employee_ID (v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS 
    session_user VARCHAR2(30);
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    ELSE
        RETURN '1=0';
    END IF;
END delete_credentials_past_credentials_by_employee_ID;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'credentials',
        policy_name => 'read_credentials_by_employee_ID_POLICY',
        policy_function => 'read_credentials_past_credentials_by_employee_ID',
        statement_types => 'select'); 
END;
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'credentials',
        policy_name => 'delete_credentials_by_employee_ID_POLICY',
        policy_function => 'delete_credentials_past_credentials_by_employee_ID',
        statement_types => 'delete'); 
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'past_credentials',
        policy_name => 'read_past_credentials_by_employee_ID_POLICY',
        policy_function => 'read_credentials_past_credentials_by_employee_ID',
        statement_types => 'select');  
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'past_credentials',
        policy_name => 'delete_past_credentials_by_employee_ID_POLICY',
        policy_function => 'delete_credentials_past_credentials_by_employee_ID',
        statement_types => 'delete');  
END;