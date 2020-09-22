CREATE OR REPLACE FUNCTION read_jobs_by_corporation_groups(v_schema VARCHAR2, v_bj VARCHAR2)
RETURN VARCHAR2 AS
    session_user VARCHAR2(30);
    group_type VARCHAR2(20);
    country_id NUMBER;
   

BEGIN
	session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    country_id := SYS_CONTEXT('EMPLOYEE_MGMT', 'COUNTRY_ID');
	group_type := SYS_CONTEXT('EMPLOYEE_MGMT', 'GROUP_TYPE');

    IF (session_user = 'SYSTEM' OR group_type = 'hr' ) THEN
        RETURN '';
	ELSE 
        RETURN '1=2';
    END IF;

 
END read_jobs_by_corporation_groups;
/

BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'jobs',
        policy_name=> 'read_jobs_by_corporation_groups', 
        policy_function => 'read_jobs_by_corporation_groups',
        sec_relevant_cols=>'MIN_SALARY, MAX_SALARY',
        sec_relevant_cols_opt => dbms_rls.ALL_ROWS,        
        statement_types => 'SELECT',
        update_check => TRUE);
END;

