-- This test file is for the user OWEN with password of OWEN.
-- OWEN is a manager in Software Development stationed in Singapore.
-- Software Development belongs to a normal group type in the HR system.
SET ROLE NON_SYSTEM, MANAGER;

-- Expected: Should only return OWEN's data plus its subordinate's data.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT('id')
        INTO counter
        FROM SYSTEM.credentials C
        INNER JOIN SYSTEM.employees E 
        ON C.employee_id = E.id;
    IF counter != 5 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of employees.');
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
        WHERE id = 1;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.employees_sensitive_data WHERE id = 1;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
END;
/
ROLLBACK;