create or replace NONEDITIONABLE FUNCTION update_delete_employee_data_by_corporation_groups(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS 
    condition VARCHAR2(255);
    sessionUser VARCHAR2(30);
    employee_id int;
    group_type varchar(20);
    country_id int;
BEGIN
    sessionUser := SYS_CONTEXT('USERENV', 'SESSION_USER');

    IF (sessionUser = 'SYSTEM') THEN
        RETURN '';
    END IF;

    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');

    IF (group_type = 'hr') THEN
        return 'EXISTS (
            SELECT 1
            FROM employees E
            INNER JOIN corporation_groups CG ON E.corporation_group_id = CG.id 
            WHERE E.corporation_group_id = CG.id AND LOC.country_id = ' || country_id || ' )';
    ELSE
        condition := 'id = ' || employee_id;
        return condition;
    END IF;
END update_delete_employee_data_by_corporation_groups;