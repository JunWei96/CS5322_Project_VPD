-- This test file is for the user DUKE with password of DUKE.
-- DUKE is an auditor stationed in Singapore.
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
-- Expected: Should be able to update/delete its own claims.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.claims SET 
        amount = 10000
        WHERE id = 17;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
    END IF;
    DELETE SYSTEM.claims WHERE id = 17;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row');
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should not be able to update/delete other employee's records.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.claims SET 
        amount = 10000
        WHERE id = 2;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.claims WHERE id = 2;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
END;
/
ROLLBACK;