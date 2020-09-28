-- This test file is for the user OWEN with password of OWEN.
-- OWEN is a manager in Software Development stationed in Singapore.
-- Software Development belongs to a normal group type in the HR system.
CONNECT OWEN/OWEN;
SET ROLE NON_SYSTEM, MANAGER;

SET SERVEROUTPUT ON;

-- Expected: Should not be able to update leaves for other non-surbordinates.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        cancellation_status = 'approved'
        WHERE id = 20;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
        ROLLBACK;
    END IF;
    DELETE SYSTEM.leaves WHERE id = 20;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row.' );
        ROLLBACK;
    END IF;
END;
/
-- Expected: Should not be able to update cancellation_status surbordinates when cacellation_application != applied.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        cancellation_status = 'approved'
        WHERE id = 88;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
        ROLLBACK;
    END IF;
END;
/
-- Expected: Should be able to update cancellation_status surbordinates when cacellation_application = applied.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        cancellation_status = 'approved'
        WHERE id = 86;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should be able to confirm leaves from employee under him in Singapore. Also should not able to confirm leaves for non-surbordinates
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        application_status = 'approved'
        WHERE id = 81;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
        ROLLBACK;
    END IF;
    ROLLBACK;
    UPDATE SYSTEM.leaves SET 
        application_status = 'approved'
        WHERE id = 3;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
    ROLLBACK;        
END;
