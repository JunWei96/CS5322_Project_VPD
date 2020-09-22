-- This test file is for the user STAFFORD with password of STAFFORD.
-- STAFFORD is in finance stationed in Singapore.
SET ROLE NON_SYSTEM;

-- Expected: Should only return the data from all the employees in Singapore.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(E.id)
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
    SELECT DISTINCT COUNT(C.salary)
        INTO counter
        FROM SYSTEM.employees_sensitive_data C
        INNER JOIN SYSTEM.employees E 
        ON C.id = E.id;
    IF counter != 14 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of employees salary.');
    END IF;
END;
/
-- Expected: Should not be able to update/delete other employee's salary.
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
-- Expected: Should not be able to update/delete his own salary.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.employees_sensitive_data SET 
        salary = 10000
        WHERE id = 6;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.employees_sensitive_data WHERE id = 6;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
END;
/
ROLLBACK;