-- This test file is for the user XERXES with password of XERXES.
-- XERXES is a HR stationed in Singapore.
CONNECT XERXES/XERXES;
SET ROLE NON_SYSTEM, HR;


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