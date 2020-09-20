create or replace NONEDITIONABLE FUNCTION write_delete_create_job_history_by_corporation_groups (v_schema IN VARCHAR2, v_obj IN VARCHAR2)
    RETURN VARCHAR2 AS 
    condition VARCHAR2 (255);
    sessionUser VARCHAR2 (30);
    employee_id int;
    corp_group_id int;
    group_type varchar(20);
    location_id int;
    country_id int;

BEGIN
    sessionUser := SYS_CONTEXT('USERENV', 'SESSION_USER');
    IF (sessionUser = 'SYSTEM') THEN
    RETURN '';
    END IF;

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');

    IF (group_type = 'hr') THEN
        return 'EXISTS (
            SELECT 1
            FROM employees E
            INNER JOIN corporation_groups CG ON E.corporation_group_id = CG.id 
            INNER JOIN locations LOC ON LOC.id = CG.location_id
            WHERE E.id= job_history.employee_id AND LOC.country_id = ' || country_id || ' )';
    ELSE
        return '1=0';
    END IF;
END write_delete_create_job_history_by_corporation_groups;