-- This test file is for the user XERXES with password of XERXES.
-- XERXES is a HR stationed in Singapore.
CONNECT XERXES/XERXES;
SET ROLE NON_SYSTEM, HR;
SET SERVEROUTPUT ON;
-- Expected: Should only return all local payslips.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) 
    INTO counter FROM SYSTEM.payslips;
    IF counter != 58 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of employees.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('local employee=' || counter);
        DBMS_OUTPUT.PUT_LINE('READ Test Passed');
    END IF;
END;
/
/
/
-- Expected: Should be able to update/delete payslips from employee in Singapore.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.payslips SET 
        amount_paid = 100000
        WHERE id = 25;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ELSE
        DBMS_OUTPUT.PUT_LINE('ABLE TO UPDTAE LOCAL Test Passed');
    END IF;
    DELETE SYSTEM.payslips 
        WHERE id = 25;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row.');
        ELSE
         DBMS_OUTPUT.PUT_LINE('ABLE TO DELETE LOCAL Test Passed');
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should not be able to update/delete employee's from other country.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.payslips SET 
        amount_paid = 10000
        WHERE id = 80;
    counter := SQL%rowcount;
    IF counter != null THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
        ELSE
        DBMS_OUTPUT.PUT_LINE('UNABLE TO UPDTAE OTHER Test Passed');
    END IF;
    DELETE SYSTEM.payslips 
    WHERE id = 80;
    counter := SQL%rowcount;
    IF counter != null THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
        ELSE
        DBMS_OUTPUT.PUT_LINE('UNABLE TO UPDTAE OTHER Test Passed');
    END IF;
    ROLLBACK;
END;