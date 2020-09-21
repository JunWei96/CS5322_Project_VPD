CREATE OR REPLACE FUNCTION jobs_by_corporation_groups(v_schema VARCHAR2, v_bj VARCHAR2)
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
--
--    IF (group_type = 'hr' ) THEN
--        RETURN 'EXISTS (
--            SELECT *
--            FROM EMPLOYEES E
--            INNER JOIN CORPORATION_GROUPS CG ON E.CORPORATION_GROUP_ID = CG.ID
--            INNER JOIN LOCATIONS L ON L.ID = CG.LOCATION_ID
--            WHERE L.COUNTRY_ID = ' || country_id ||' AND E.JOB_ID = jobs.id)';
--    ELSE
--        RETURN '1=2';
--
--    END IF;
 
END jobs_by_corporation_groups;
/

BEGIN 
    DBMS_RLS.ADD_POLICY(
        object_name => 'jobs',
        policy_name=> 'jobs_by_corporation_groups', 
        policy_function => 'jobs_by_corporation_groups',
        statement_types => 'UPDATE,DELETE,INSERT',
        update_check => TRUE);
END;