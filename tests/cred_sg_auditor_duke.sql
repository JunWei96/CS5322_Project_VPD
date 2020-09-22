-- This test file is for the user DUKE with password of DUKE.
-- DUKE is an auditor stationed in Singapore.
SET ROLE NON_SYSTEM;

-- Expected: Should his own credential.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) INTO counter FROM SYSTEM.credentials;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of credential.');
    END IF;
END;
/
-- Expected: Should return his own past credentials but he has no past credentials.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) INTO counter FROM SYSTEM.past_credentials;
    IF counter != 0 THEN
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
-- Expected: Should be able to update own cridential but cannot delete its own cridential.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.credentials SET 
        hashed_password = 10000
        WHERE employee_id = 4;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
    END IF;
    DELETE SYSTEM.credentials WHERE employee_id = 4;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
    ROLLBACK;
END;
/
ROLLBACK;