-- This test file is for the user STAFFORD with password of STAFFORD.
-- STAFFORD is in finance stationed in Singapore.
CONNECT STAFFORD/STAFFORD;
SET ROLE NON_SYSTEM;

-- Expected: Should only return the claims from all the employees in Singapore.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*)
        INTO counter
        FROM SYSTEM.claims C 
        INNER JOIN SYSTEM.employees E 
        ON C.creator = E.id;
    IF counter != 75 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of employees.');
    END IF;
END;
/
-- Expected: Should not be able to update/delete employee's from other country.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.claims SET 
        amount = 10000
        WHERE id = 44;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.claims WHERE id = 44;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
END;
/
-- Expected: Should be able to update finance_approved_by
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.claims SET 
        finance_approved_by = 5
        WHERE id = 42;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should be able to update finance_approved_by');
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should not be able to update hr_approved_by
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.claims SET 
        hr_approved_by = 5
        WHERE id = 42;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should not able to update hr_approved_by');
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should not be able to update/delete on something that is approved
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.claims SET 
        amount = 10000
        WHERE id = 42;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.claims WHERE id = 42;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should be able to update/delete on something that is not yet approved
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.claims SET 
        amount = 10000
        WHERE id = 58;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
    END IF;
    DELETE SYSTEM.claims WHERE id = 58;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row');
    END IF;
    ROLLBACK;
END;
ROLLBACK;