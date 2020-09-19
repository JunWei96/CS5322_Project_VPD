CREATE OR REPLACE FUNCTION Payslip_by_employee_ID(p_schema IN VARCHAR2, p_obj IN VARCHAR2)
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
         
    IF (group_type = 'hr' OR group_type = 'finance') THEN
        return 'EXISTS (
            SELECT 1
            FROM employees E
            INNER JOIN corporation_groups CG ON E.corporation_group_id = CG.id 
            INNER JOIN locations LOC ON LOC.id = CG.location_id
            WHERE E.id = recipient AND LOC.country_id = ' || country_id || ' )';
    ELSE
        condition:= 'recipient = ' || employee_id;
        
        return condition;
    END IF;
END Payslip_by_employee_ID;

/
BEGIN
	DBMS_RLS.ADD_POLICY (
		object_name	=>	'payslips',
		policy_name	=>	'Read_Payslip_by_employee_ID_policy',
		policy_function	=>	'Payslip_by_employee_ID',
        statement_types => 'SELECT');
END;

BEGIN
	DBMS_RLS.ADD_POLICY (
		object_name	=>	'payslips',
		policy_name	=>	'SELECT_UPDATE_Payslip_by_employee_ID_policy',
		policy_function	=>	'Payslip_by_employee_ID',
        statement_types => 'SELECT,UPDATE');
END;

/
BEGIN
	DBMS_RLS.DROP_POLICY (
        object_name => 'payslips',
		policy_name	=>	'SELECT_UPDATE_Payslip_by_employee_ID_policy');
END;

BEGIN
	DBMS_RLS.DROP_POLICY (
        object_name => 'payslips',
		policy_name	=>	'READ_Payslip_by_employee_ID_policy');
END;