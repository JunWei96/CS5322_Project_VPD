-- This test file is for the user OWEN with password of OWEN.
-- OWEN is a manager in Software Development stationed in Singapore.
-- Software Development belongs to a normal group type in the HR system.
CONNECT OWEN/OWEN;
SET ROLE NON_SYSTEM, MANAGER;

-- Expected: Should only return OWEN's claims plus its subordinate's claims.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*)
        INTO counter
        FROM SYSTEM.claims C
        INNER JOIN SYSTEM.employees E 
        ON C.creator = E.id;
    IF counter != 28 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of employees.');
    END IF;
END;
/
-- Expected: Should not be able to update/delete other employee's records.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.claims SET 
        amount = 10000
        WHERE id = 2;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.claims WHERE id = 2;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
END;
/
-- Expected Should be able to insert claim for himself.
DECLARE
    counter INT;
BEGIN
    INSERT INTO SYSTEM.claims (id,creator,hr_approved_by,finance_approved_by,amount) VALUES (101,1,14,20,5997);
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should insert 1 row');
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should not be able to insert claim for others.
DECLARE
    counter INT;
BEGIN
    INSERT INTO SYSTEM.claims (id,creator,hr_approved_by,finance_approved_by,amount) VALUES (101,2,14,20,5997);
    RAISE_APPLICATION_ERROR(-20000, 'Should not insert row for others');
    ROLLBACK;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('SUCCESS');
END;
/
-- Expected: Should not be able to update/delete on something that is approved
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.claims SET 
        amount = 10000
        WHERE id = 42;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
    END IF;
    DELETE SYSTEM.claims WHERE id = 42;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 0 row');
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should be able to update/delete on something that is not yet approved
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.claims SET 
        amount = 10000
        WHERE id = 58;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
    END IF;
    DELETE SYSTEM.claims WHERE id = 58;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row');
    END IF;
    ROLLBACK;
END;
ROLLBACK;