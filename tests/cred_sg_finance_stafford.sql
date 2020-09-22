-- This test file is for the user STAFFORD with password of STAFFORD.
-- STAFFORD is in finance stationed in Singapore.
SET ROLE NON_SYSTEM;

-- Expected: Should return employee's current credentials.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) INTO counter FROM SYSTEM.credentials;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of credential.');
    END IF;
END;
/
-- Expected: Should return employee's past credentials.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) INTO counter FROM SYSTEM.past_credentials;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of past credential.');
    END IF;
END;
/
-- Expected: Should not be able to update/delete data for others.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.credentials SET 
        hashed_password = 10000
        WHERE employee_id = 1;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.credentials WHERE employee_id = 1;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should not be able to update/delete data for others.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.past_credentials SET 
        hashed_password = 10000
        WHERE employee_id = 1;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.past_credentials WHERE employee_id = 1;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should be able to update own credential but cannot delete its own credential.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.credentials SET 
        hashed_password = 10000
        WHERE employee_id = 5;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
    END IF;
    DELETE SYSTEM.credentials WHERE employee_id = 5;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
    ROLLBACK;
END;
/
ROLLBACK;