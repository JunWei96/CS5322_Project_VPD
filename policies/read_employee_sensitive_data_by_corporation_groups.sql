create or replace NONEDITIONABLE FUNCTION read_employee_sensitive_data_by_corporation_groups(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS 
    condition VARCHAR2(255);
    sessionUser VARCHAR2(30);
    employee_id int;
    group_type varchar(20);
    country_id int;
    is_manager int;
BEGIN
    sessionUser := SYS_CONTEXT('USERENV', 'SESSION_USER');

    IF (sessionUser = 'SYSTEM') THEN
        RETURN '';
    END IF;

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');
    is_manager := SYS_CONTEXT('EMPLOYEE_MGMT', 'IS_MANAGER');

    IF (group_type = 'hr' OR group_type = 'finance' OR group_type = 'auditor') THEN
        return 'EXISTS (
            SELECT 1
            FROM employees E
            INNER JOIN corporation_groups CG ON E.corporation_group_id = CG.id 
            INNER JOIN locations LOC ON LOC.id = CG.location_id
            WHERE E.id = employees_sensitive_data.id AND LOC.country_id = ' || country_id || ' )';
    ELSE
        condition := 'id = ' || employee_id;
        IF (is_manager = 1) THEN
            return condition || ' OR ' || 'EXISTS (
                SELECT 1
                FROM employees E
                WHERE E.id = employees_sensitive_data.id AND E.manager_id = ' || employee_id || ')';
        ELSE
            return condition;
        END IF;
    END IF;
END read_employee_sensitive_data_by_corporation_groups;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'employees_sensitive_data',
        policy_name => 'read_employee_sensitive_data_by_corporation_groups_POLICY',
        policy_function => 'read_employee_sensitive_data_by_corporation_groups',
        statement_types => 'select');  
END;