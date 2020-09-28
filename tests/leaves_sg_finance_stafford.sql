-- This test file is for the user STAFFORD with password of STAFFORD.
-- STAFFORD is in finance stationed in Singapore.
CONNECT STAFFORD/STAFFORD;
SET ROLE NON_SYSTEM;

-- should be able to apply leaves that are not applied
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        leave_application = 'applied'
        WHERE id = 32;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/
-- should not be able to update leave that is not applied.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        leave_application = 'not_applied'
        WHERE id = 20;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
