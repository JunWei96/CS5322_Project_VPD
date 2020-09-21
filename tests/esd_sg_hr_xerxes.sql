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
-- Expected: Should not be able to update/delete other employee's salary not in SG.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.employees_sensitive_data SET 
        salary = 10000
        WHERE id = 8;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.employees_sensitive_data WHERE id = 8;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
END;
/
ROLLBACK;
-- Expected: Should be able to update/delete data from employee in Singapore.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.employees_sensitive_data SET 
        salary = 10000
        WHERE id = 16;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
    END IF;
    DELETE SYSTEM.employees_sensitive_data WHERE id = 16;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row.');
    END IF;
    ROLLBACK;
END;
/
ROLLBACK;