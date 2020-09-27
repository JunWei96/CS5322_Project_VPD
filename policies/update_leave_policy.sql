-- Only HR can delete or insert leaves for local employees
CREATE OR REPLACE FUNCTION delete_insert_leaves(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    condition VARCHAR2(255);
    session_user VARCHAR2(30);
    employee_id NUMBER;
    group_type VARCHAR2(20);
    country_id NUMBER;
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');

    IF (group_type = 'hr') THEN
        RETURN 'EXISTS(
            SELECT 1
            FROM EMPLOYEES E
            INNER JOIN CORPORATION_GROUPS CG ON E.CORPORATION_GROUP_ID = CG.ID
            INNER JOIN LOCATIONS L ON L.ID = CG.LOCATION_ID
            WHERE L.COUNTRY_ID = ' || country_id || ' AND leaves.emp_id= E.id)';
    ELSE
        return '1=0';
    END IF;
END delete_insert_leaves;
/
-- hr and self only allowed to edit these values when application_status is NULL or rejected.
CREATE OR REPLACE FUNCTION update_type_start_end_date_remark_leave_application(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    condition VARCHAR2(255);
    session_user VARCHAR2(30);
    employee_id NUMBER;
    group_type VARCHAR2(20);
    country_id NUMBER;
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');

    condition := '(leaves.application_status IS NULL OR leaves.application_status = ''rejected'')';
    IF (group_type = 'hr' ) THEN
        RETURN condition || ' AND EXISTS(
            SELECT 1
            FROM EMPLOYEES E
            INNER JOIN CORPORATION_GROUPS CG ON E.CORPORATION_GROUP_ID = CG.ID
            INNER JOIN LOCATIONS L ON L.ID = CG.LOCATION_ID
            WHERE L.COUNTRY_ID = ' || country_id || ' AND leaves.emp_id= E.id)';
    ELSE
        return condition || ' AND ' || 'leaves.emp_id = ' || employee_id;
    END IF;
END update_type_start_end_date_remark_leave_application;
/
-- only manager or hr can change application status when employee applied for leave.
CREATE OR REPLACE FUNCTION update_application_status_leave(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    condition VARCHAR2(255);
    session_user VARCHAR2(30);
    employee_id NUMBER;
    group_type VARCHAR2(20);
    country_id NUMBER;
    is_manager int;
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');
    is_manager := SYS_CONTEXT('EMPLOYEE_MGMT', 'IS_MANAGER');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');

    condition := 'leave_application = ''applied''';
    IF (group_type = 'hr') THEN
        RETURN condition || ' AND EXISTS(
            SELECT 1
            FROM EMPLOYEES E
            INNER JOIN CORPORATION_GROUPS CG ON E.CORPORATION_GROUP_ID = CG.ID
            INNER JOIN LOCATIONS L ON L.ID = CG.LOCATION_ID
            WHERE L.COUNTRY_ID = ' || country_id || ' AND leaves.emp_id= E.id)';
    ELSIF (is_manager = 1) THEN
        return condition || ' AND EXISTS(
            SELECT 1 FROM EMPLOYEES E
            WHERE E.MANAGER_ID = ' || employee_id || ' AND e.id = leaves.emp_id)';
    ELSE
        return '1=0';
    END IF;
END update_application_status_leave;
/
-- only can update cancellation application when application = approved.
CREATE OR REPLACE FUNCTION update_cancellation_application_leave(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    condition VARCHAR2(255);
    session_user VARCHAR2(30);
    employee_id NUMBER;
    group_type VARCHAR2(20);
    country_id NUMBER;
    is_manager int;
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');
    is_manager := SYS_CONTEXT('EMPLOYEE_MGMT', 'IS_MANAGER');
    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');

    condition := 'application_status = ''approved''';
    IF (group_type = 'hr') THEN
        RETURN condition || ' AND EXISTS(
            SELECT 1
            FROM EMPLOYEES E
            INNER JOIN CORPORATION_GROUPS CG ON E.CORPORATION_GROUP_ID = CG.ID
            INNER JOIN LOCATIONS L ON L.ID = CG.LOCATION_ID
            WHERE L.COUNTRY_ID = ' || country_id || ' AND leaves.emp_id= E.id)';
    ELSIF (is_manager = 1) THEN
        return condition || ' AND EXISTS(
            SELECT 1 FROM EMPLOYEES E
            WHERE E.MANAGER_ID = ' || employee_id || ' AND e.id = leaves.emp_id)';
    ELSE
        return condition || ' AND leaves.emp_id = ' || employee_id;
    END IF;
END update_cancellation_application_leave;
/
-- No one can update emp_id
CREATE OR REPLACE FUNCTION update_emp_id_leave(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    condition VARCHAR2(255);
    session_user VARCHAR2(30);
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    ELSE
        return '1=0';
    END IF;
END update_emp_id_leave;
/
-- only hr or manager can update this cancellation_status AND when cacellation_application = applied.
CREATE OR REPLACE FUNCTION update_cancellation_status_leave(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    condition VARCHAR2(255);
    session_user VARCHAR2(30);
    employee_id NUMBER;
    group_type VARCHAR2(20);
    country_id NUMBER;
    is_manager int;
BEGIN
    session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');
    is_manager := SYS_CONTEXT('EMPLOYEE_MGMT', 'IS_MANAGER');

    IF (session_user = 'SYSTEM') THEN
        RETURN '';
    END IF;

    employee_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'EMP_ID');
    group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');

    condition := 'cancellation_application = ''applied''';
    IF (group_type = 'hr') THEN
        RETURN condition || ' AND EXISTS(
            SELECT 1
            FROM EMPLOYEES E
            INNER JOIN CORPORATION_GROUPS CG ON E.CORPORATION_GROUP_ID = CG.ID
            INNER JOIN LOCATIONS L ON L.ID = CG.LOCATION_ID
            WHERE L.COUNTRY_ID = ' || country_id || ' AND leaves.emp_id= E.id)';
    ELSIF (is_manager = 1) THEN
        return condition || ' AND EXISTS(
            SELECT 1 FROM EMPLOYEES E
            WHERE E.MANAGER_ID = ' || employee_id || ' AND e.id = leaves.emp_id)';
    ELSE
        return '1=0';
    END IF;
END update_cancellation_status_leave;
/
BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'LEAVES',
        policy_name=> 'delete_insert_leaves_policy', 
        policy_function => 'delete_insert_leaves',
        statement_types => 'DELETE,INSERT',
        update_check => TRUE);
END;
/
BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'LEAVES',
        policy_name=> 'update_type_start_end_date_remark_leave_application_policy', 
        policy_function => 'update_type_start_end_date_remark_leave_application',
        sec_relevant_cols => 'leave_type,start_date,end_date,leave_application,remark',
        statement_types => 'UPDATE',
        update_check => TRUE);
END;
/
BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'LEAVES',
        policy_name=> 'update_application_status_leave_policy', 
        policy_function => 'update_application_status_leave',
        sec_relevant_cols => 'application_status',
        statement_types => 'UPDATE',
        update_check => TRUE);
END;
/
BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'LEAVES',
        policy_name=> 'update_cancellation_application_leave_policy', 
        policy_function => 'update_cancellation_application_leave',
        sec_relevant_cols => 'cancellation_application',
        statement_types => 'UPDATE');
END;
/
BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'LEAVES',
        policy_name=> 'update_cancellation_status_leave_policy', 
        policy_function => 'update_cancellation_status_leave',
        sec_relevant_cols => 'cancellation_status',
        statement_types => 'UPDATE',
        update_check => TRUE);
END;
/
BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'LEAVES',
        policy_name=> 'update_emp_id_leave_policy', 
        policy_function => 'update_emp_id_leave',
        sec_relevant_cols => 'emp_id',
        statement_types => 'UPDATE',
        update_check => TRUE);
END;
/