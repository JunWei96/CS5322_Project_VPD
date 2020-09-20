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