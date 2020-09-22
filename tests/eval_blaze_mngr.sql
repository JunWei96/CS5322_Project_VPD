-- This test file is for the user BLAZE  with password of BLAZE.
-- OWEN is a Manager stationed in Singapore.
SET ROLE NON_SYSTEM, MANAGER;

-- Expected: Should only return the evaluations from all the her team in Singapore.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) INTO counter FROM SYSTEM.evaluations;
    IF counter != 5 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should return some evaluations.');
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should be able to update leaves from his team in Singapore.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        status = 'approved'
        WHERE id = 77;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/

-- Create a leave for an employee
DECLARE
    counter INT;
BEGIN
    INSERT INTO SYSTEM.leaves (ID,EMP_ID, LEAVE_TYPE, STATUS) VALUES (101,12, 'mc', 'approved');
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should add 1 row.' );
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/

-- Delete a leave for an employee
DECLARE
    counter INT;
BEGIN
    DELETE SYSTEM.leaves WHERE id = 96;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row.' );
        ROLLBACK;
    END IF;
END;
/
