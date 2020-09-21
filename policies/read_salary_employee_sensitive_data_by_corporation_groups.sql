create or replace NONEDITIONABLE FUNCTION read_salary_employee_sensitive_data_by_corporation_groups(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
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

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');

    IF (group_type = 'hr' OR group_type = 'finance') THEN
        return 'EXISTS (
            SELECT 1
            FROM employees E
            INNER JOIN corporation_groups CG ON E.corporation_group_id = CG.id 
            INNER JOIN locations LOC ON LOC.id = CG.location_id
            WHERE LOC.country_id = ' || country_id || ' )';
    ELSE
        condition := 'id = ' || employee_id;
        return condition;
    END IF;
END read_salary_employee_sensitive_data_by_corporation_groups;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'employees_sensitive_data',
        policy_name => 'read_salary_employee_sensitive_data_by_corporation_groups_POLICY',
        policy_function => 'read_salary_employee_sensitive_data_by_corporation_groups',
        statement_types => 'select',
        sec_relevant_cols => 'SALARY',
        sec_relevant_cols_opt=> dbms_rls.ALL_ROWS);   
END;
/
--BEGIN
--    DBMS_RLS.DROP_POLICY(
--        object_name => 'employees_sensitive_data',
--        policy_name => 'READ_SALARY_EMPLOYEE_SENSITIVE_DATA_BY_CORPORATION_GROUPS_POLICY');
--END;