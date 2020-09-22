-- This test file is for the user XERXES with password of XERXES.
-- XERXES is a HR stationed in Singapore.
CONNECT XERXES/XERXES;
SET ROLE NON_SYSTEM, HR;

-- Expected: Should be able to update/insert leaves from employee in Singapore.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        status = 'approved'
        WHERE id = 73;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
    DELETE SYSTEM.leaves WHERE id = 27;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row.' );
        ROLLBACK;
    END IF;
    INSERT INTO SYSTEM.leaves (ID,EMP_ID, LEAVE_TYPE, STATUS) VALUES (101,11, 'mc', 'approved');
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should add 1 row.' );
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
