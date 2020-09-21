-- This test file is for the user XERXES with password of XERXES.
-- XERXES is a HR stationed in Singapore.
SET ROLE NON_SYSTEM, HR;

-- Expected: Should only return the data from all the employees in Singapore.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT('id')
        INTO counter
        FROM SYSTEM.employees_sensitive_data C
        INNER JOIN SYSTEM.employees E 
        ON C.id = E.id;
    IF counter != 14 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of employees.');
    END IF;
END;
/
-- Expected: Should only return the salary from all the employees in Singapore.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT('salary')
        INTO counter
        FROM SYSTEM.employees_sensitive_data C
        INNER JOIN SYSTEM.employees E 
        ON C.id = E.id;
    IF counter != 14 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of employees.');
    END IF;
END;
/
-- Expected: Should be able to update/delete claims from employee in Singapore.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.claims SET 
        amount = 10000
        WHERE id = 42;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
    END IF;
    DELETE SYSTEM.claims WHERE id = 42;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row.');
    END IF;
    ROLLBACK;
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
    ROLLBACK;
END;
/
ROLLBACK;