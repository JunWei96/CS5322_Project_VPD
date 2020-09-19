CREATE OR REPLACE FUNCTION read_claims_by_corporation_group(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
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
    
    IF (group_type = 'hr') THEN
        return 'EXISTS (
            SELECT 1
            FROM employees E
            INNER JOIN corporation_groups CG ON E.corporation_group_id = CG.id 
            INNER JOIN locations LOC ON LOC.id = CG.location_id
            WHERE E.id = creator AND LOC.country_id = ' || country_id || ' )';
    ELSE
        return 'creator = ' || employee_id;
    END IF;
END read_claims_by_corporation_group;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'claims',
        policy_name => 'read_claims_by_corporation_group_policy',
        policy_function => 'read_claims_by_corporation_group');
END;
