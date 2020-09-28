-- This test file is for the user XERXES with password of XERXES.
-- XERXES is a HR stationed in Singapore.
CONNECT XERXES/XERXES;
SET ROLE NON_SYSTEM, HR;

-- Expected: Should be able to delete/insert leaves from employee in Singapore.
DECLARE
    counter INT;
BEGIN
    DELETE SYSTEM.leaves WHERE id = 27;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row.' );
        ROLLBACK;
    END IF;
    ROLLBACK;

    INSERT INTO SYSTEM.leaves (ID,EMP_ID, LEAVE_TYPE, LEAVE_APPLICATION) VALUES (101,11, 'mc', 'not_applied');
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should add 1 row.' );
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/
-- self allowed to edit these values when application_status is NULL or rejected. update_type_start_end_date_remark_leave_application
-- should be able to allow MACK to edit when application_status is NULL or rejected.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        leave_type = 'mc'
        WHERE id = 3;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
END;
/
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        start_date = '01-OCT-20'
        WHERE id = 3;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
END;
/
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        end_date = '01-OCT-20'
        WHERE id = 3;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
END;
/
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        remark = 'Fever'
        WHERE id = 3;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
END;
/
-- Expected: Should be able to confirm leaves from employee in Singapore. But not outside of singapore.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        application_status = 'approved'
        WHERE id = 8;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
        ROLLBACK;
    END IF;
    ROLLBACK;
    UPDATE SYSTEM.leaves SET 
        application_status = 'approved'
        WHERE id = 3;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 1 row');
        ROLLBACK;
    END IF;
    ROLLBACK;
END;