CREATE OR REPLACE PACKAGE EMPLOYEE_VPD AS
    PROCEDURE set_context;
END;
/
CREATE OR REPLACE PACKAGE BODY EMPLOYEE_VPD IS
    PROCEDURE set_context IS
        sessionUser VARCHAR2(30);
        employee_id INT;
        corp_group_id INT;
        group_type VARCHAR2(20);
        location_id INT;
        country_id INT;
    BEGIN
        sessionUser := SYS_CONTEXT('USERENV','SESSION_USER');
        IF (sessionUser = 'SYSTEM') THEN
            RETURN;
        END IF;
        
        BEGIN
            SELECT id, corporation_group_id 
                INTO employee_id, corp_group_id 
                FROM employees 
                WHERE slug = sessionUser;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Unauthorized employee.');
        END;
        
        SELECT group_type, location_id
            INTO group_type, location_id
            FROM corporation_groups 
            WHERE id = corp_group_id;
        SELECT country_id
            INTO country_id
            FROM locations
            WHERE id = location_id;
        
        DBMS_SESSION.set_context('EMPLOYEE_MGMT', 'EMP_ID', employee_id);
        DBMS_SESSION.set_context('EMPLOYEE_MGMT', 'CORP_GROUP_ID', corp_group_id);
        DBMS_SESSION.set_context('EMPLOYEE_MGMT', 'GROUP_TYPE', group_type);
        DBMS_SESSION.set_context('EMPLOYEE_MGMT', 'LOCATION_ID', location_id);
        DBMS_SESSION.set_context('EMPLOYEE_MGMT', 'COUNTRY_ID', country_id);
    END set_context;
END EMPLOYEE_VPD;
/
GRANT EXECUTE ON EMPLOYEE_VPD TO PUBLIC;
