@employee_vpd.sql
/
-- Create context necessary for securing the database.
CREATE OR REPLACE CONTEXT EMPLOYEE_MGMT USING EMPLOYEE_VPD;
/
CREATE OR REPLACE TRIGGER SET_EMPLOYEE_MGMT_CONTEXT
    AFTER LOGON ON DATABASE 
    BEGIN
        EMPLOYEE_VPD.set_context;
    END;
/