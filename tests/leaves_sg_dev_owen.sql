-- This test file is for the user OWEN with password of OWEN.
-- OWEN is a manager in Software Development stationed in Singapore.
-- Software Development belongs to a normal group type in the HR system.
CONNECT OWEN/OWEN;
SET ROLE NON_SYSTEM, MANAGER;

-- Expected: Should be able to update/insert leaves for subordinates.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        status = 'approved'
        WHERE id = 16;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
    DELETE SYSTEM.leaves WHERE id = 16;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row.' );
        ROLLBACK;
    END IF;
    INSERT INTO SYSTEM.leaves (ID,EMP_ID, LEAVE_TYPE, STATUS) VALUES (101,7, 'mc', 'approved');
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should add 1 row.' );
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/
-- should be able to update its own leaves
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        status = 'approved'
        WHERE id = 45;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should not be able to update leaves for other non-surbordinates.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        status = 'approved'
        WHERE id = 20;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
    DELETE SYSTEM.leaves WHERE id = 20;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row.' );
        ROLLBACK;
    END IF;
END;


