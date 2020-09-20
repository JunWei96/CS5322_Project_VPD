-- This test file is for the user DUKE with password of DUKE.
-- DUKE is an auditor stationed in Singapore.
SET ROLE NON_SYSTEM;

-- Expected: Should only return the payslip from all the employees in Singapore.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) INTO counter FROM SYSTEM.payslips;
    IF counter != 58 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of employees.');
    END IF;
END;
/
-- Expected: DUKE Should not be able to update/delete any payslip.
DECLARE
    counter INT;
BEGIN
    DBMS_OUTPUT.PUT_LINE('START');
    UPDATE SYSTEM.payslips SET 
        amount_paid = 100000
        WHERE id = 25;
    counter := SQL%rowcount;
    IF counter != null THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
        ELSE
        DBMS_OUTPUT.PUT_LINE('UPDATE Test Passed');
    END IF;
    DELETE SYSTEM.payslips 
    WHERE id = 25;
    counter := SQL%rowcount;
    IF counter != null THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
        ELSE
        DBMS_OUTPUT.PUT_LINE('DELETE Test Passed');
    END IF;
    ROLLBACK;
END;
/
ROLLBACK;