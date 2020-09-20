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

    condition := 'EXISTS (
            SELECT 1
            FROM past_credentials pc
            INNER JOIN credentials cr ON pc.current_credential = cr.id
            WHERE pc.employee_id = ' || employee_id || ')';
    RETURN condition;
END update_past_credentials_by_employee_ID;