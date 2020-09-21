-- This test file is for the user XERXES with password of XERXES.
-- XERXES is a HR stationed in Singapore.
SET ROLE NON_SYSTEM, HR;

-- Expected: Should only return the claims from all the employees in Singapore.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) INTO counter FROM SYSTEM.claims;
    IF counter != 75 THEN
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

-- Expected: Should only return the evaluations from all the employees in Singapore.
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) INTO counter FROM SYSTEM.evaluations;
    IF counter != 14 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should return some evaluations.');
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should be able to update/insert leaves from employee in Singapore.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        status = 'approved'
        WHERE id = 73;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
    DELETE SYSTEM.leaves WHERE id = 27;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row.' );
        ROLLBACK;
    END IF;
    INSERT INTO SYSTEM.leaves (ID,EMP_ID, LEAVE_TYPE, STATUS) VALUES (101,11, 'mc', 'approved');
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should add 1 row.' );
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/

-- Expected: Should be able to update/delete/insert jobs.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.jobs SET 
        max_salary = 6000
        WHERE id = 1;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 job');
        ROLLBACK;
    END IF;
    INSERT INTO SYSTEM.jobs (ID,JOB_TITLE, min_salary, max_salary) VALUES (10,'scrum master', 4000, 6000);
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should add 1 job.' );
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/

--Expected: Should be able to delete
-- Considered successfull if it tries to delete and an integrity constraint error is raised
DECLARE
    counter INT;
BEGIN
    DELETE SYSTEM.jobs WHERE id = 9;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 job.' );
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
