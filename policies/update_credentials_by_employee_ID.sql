create or replace NONEDITIONABLE FUNCTION update_credentials_by_employee_ID (v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS 
    session_user VARCHAR2(30);
    condition VARCHAR2(255);
    employee_id int;
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    condition := 'employee_id = ' || employee_id;
    RETURN condition;
END update_credentials_by_employee_ID;