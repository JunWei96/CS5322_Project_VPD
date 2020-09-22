-- This test file is for the user OWEN with password of OWEN.
-- OWEN is a manager in Software Development stationed in Singapore.
-- Software Development belongs to a normal group type in the HR system.
SET ROLE NON_SYSTEM, MANAGER;
SET SERVEROUTPUT ON;
-- Expected: Should only return OWEN's payslip.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*)
        INTO counter
        FROM SYSTEM.payslips P
        INNER JOIN SYSTEM.employees E 
        ON P.recipient = E.id;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of employees.');
        ELSE 
        DBMS_OUTPUT.PUT_LINE('READ Test Passed');
    END IF;
END;
/
-- Expected: OWEN Should not be able to update/delete its own payslip.
DECLARE
    counter INT;
BEGIN
    --DBMS_OUTPUT.PUT_LINE('START');
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