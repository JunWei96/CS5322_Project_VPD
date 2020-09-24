CREATE OR REPLACE FUNCTION read_claims_by_corporation_group(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
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
            WHERE E.id = creator AND LOC.country_id = ' || country_id || ' )';
    ELSE
        condition := 'creator = ' || employee_id;
        IF (is_manager = 1) THEN
            return condition || ' OR ' || 'EXISTS (
                SELECT 1
                FROM employees E
                WHERE E.id = creator AND E.manager_id = ' || employee_id || ')';
        ELSE
            return condition;
        END IF;
    END IF;
END read_claims_by_corporation_group;
/
CREATE OR REPLACE FUNCTION update_amount_remark_claims_by_corporation_group(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
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
    
    condition := 'hr_approved_by IS NULL AND finance_approved_by IS NULL';
    IF (group_type = 'hr' OR group_type = 'finance') THEN
        return condition || ' AND EXISTS (
            SELECT 1
            FROM employees E
            INNER JOIN corporation_groups CG ON E.corporation_group_id = CG.id 
            INNER JOIN locations LOC ON LOC.id = CG.location_id
            WHERE E.id = creator AND LOC.country_id = ' || country_id || ' )';
    ELSE
        return condition || ' AND creator = ' || employee_id;
    END IF;
END update_amount_remark_claims_by_corporation_group;
/
CREATE OR REPLACE FUNCTION insert_claims_by_employee_id(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS 
    condition VARCHAR2(255);
    sessionUser VARCHAR2(30);
    employee_id int;
BEGIN
    sessionUser := SYS_CONTEXT('USERENV', 'SESSION_USER');
    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');

    IF (sessionUser = 'SYSTEM') THEN
        RETURN '';
    END IF;

    return 'claims.creator = ' || employee_id;
END insert_claims_by_employee_id;
/
CREATE OR REPLACE FUNCTION update_finance_approved_by_claims(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS 
    condition VARCHAR2(255);
    sessionUser VARCHAR2(30);
    employee_id int;
    group_type varchar(20);
BEGIN
    sessionUser := SYS_CONTEXT('USERENV', 'SESSION_USER');
    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');

    IF (sessionUser = 'SYSTEM') THEN
        RETURN '';
    END IF;
    
    IF (group_type = 'finance') THEN
        return '';
    ELSE
        return '1=0';
    END IF;
END update_finance_approved_by_claims;
/
CREATE OR REPLACE FUNCTION update_hr_approved_by_claims(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS 
    condition VARCHAR2(255);
    sessionUser VARCHAR2(30);
    employee_id int;
    group_type varchar(20);
BEGIN
    sessionUser := SYS_CONTEXT('USERENV', 'SESSION_USER');
    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');

    IF (sessionUser = 'SYSTEM') THEN
        RETURN '';
    END IF;
    
    IF (group_type = 'hr') THEN
        return '';
    ELSE
        return '1=0';
    END IF;
END update_hr_approved_by_claims;
/
CREATE OR REPLACE FUNCTION update_creator_of_claims(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
RETURN VARCHAR2 AS 
    condition VARCHAR2(255);
    sessionUser VARCHAR2(30);
BEGIN
    sessionUser := SYS_CONTEXT('USERENV', 'SESSION_USER');

    IF (sessionUser = 'SYSTEM') THEN
        RETURN '';
    ELSE
        return '1=0';
    END IF;
END update_creator_of_claims;
/
CREATE OR REPLACE FUNCTION delete_not_approved_claims(v_schema IN VARCHAR2, v_obj IN VARCHAR2)
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

    condition := 'hr_approved_by IS NULL AND finance_approved_by IS NULL';
    IF (group_type = 'hr' OR group_type = 'finance') THEN
        return condition || ' AND EXISTS (
            SELECT 1
            FROM employees E
            INNER JOIN corporation_groups CG ON E.corporation_group_id = CG.id 
            INNER JOIN locations LOC ON LOC.id = CG.location_id
            WHERE E.id = creator AND LOC.country_id = ' || country_id || ' )';
    ELSE
        return condition || ' AND creator = ' || employee_id;
    END IF;
END delete_not_approved_claims;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'claims',
        policy_name => 'read_claims_by_corporation_group_policy',
        policy_function => 'read_claims_by_corporation_group',
        statement_types => 'SELECT');
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'claims',
        policy_name => 'update_amount_remark_claims_by_corporation_group_policy',
        policy_function => 'update_amount_remark_claims_by_corporation_group',
        sec_relevant_cols => 'amount,remark',
        statement_types => 'UPDATE');
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'claims',
        policy_name => 'insert_claims_by_employee_id_policy',
        policy_function => 'insert_claims_by_employee_id',
        statement_types => 'INSERT',
        update_check => true);
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'claims',
        policy_name => 'update_finance_approved_by_claims_policy',
        policy_function => 'update_finance_approved_by_claims',
        statement_types => 'UPDATE',
        sec_relevant_cols => 'finance_approved_by',
        update_check => true);
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'claims',
        policy_name => 'update_hr_approved_by_claims_policy',
        policy_function => 'update_hr_approved_by_claims',
        statement_types => 'UPDATE',
        sec_relevant_cols => 'hr_approved_by',
        update_check => true);
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'claims',
        policy_name => 'delete_not_approved_claims_policy',
        policy_function => 'delete_not_approved_claims',
        statement_types => 'DELETE');
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_name => 'claims',
        policy_name => 'update_creator_of_claims_policy',
        policy_function => 'update_creator_of_claims',
        sec_relevant_cols => 'creator',
        statement_types => 'UPDATE');
END;
/
