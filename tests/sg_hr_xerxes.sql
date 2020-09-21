-- This test file is for the user XERXES with password of XERXES.
-- XERXES is a HR stationed in Singapore.
SET ROLE NON_SYSTEM, HR;

-- Expected: Should return nothing.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) INTO counter FROM SYSTEM.credentials;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of employees.');
    END IF;
END;
/
-- Expected: Should return nothing.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) INTO counter FROM SYSTEM.past_credentials;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of employees.');
    END IF;
END;
/
-- Expected: Should not be able to update/delete data for others.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.credentials SET 
        hashed_password = 10000
        WHERE id = 1;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.credentials WHERE id = 1;
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
        WHERE id = 1;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.past_credentials WHERE id = 1;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
    ROLLBACK;
END;
/
ROLLBACK;