-- This test file is for the user MACK with password of MACK.
-- MACK is a surbordinate of OWEN in Software Development stationed in Singapore.
-- Software Development belongs to a normal group type in the HR system.
CONNECT MACK/MACK;
SET ROLE NON_SYSTEM;

-- Expected: Should not be able to delete leaves from employee in Singapore.
DECLARE
    counter INT;
BEGIN
    DELETE SYSTEM.leaves WHERE id = 27;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should delete 1 row.' );
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should not be able to insert leaves from employee in Singapore.
BEGIN
    INSERT INTO SYSTEM.leaves (ID,EMP_ID, LEAVE_TYPE, LEAVE_APPLICATION) VALUES (101,11, 'mc', 'not_applied');
    RAISE_APPLICATION_ERROR(-20000, 'Should not be allowed to insert.' );
    ROLLBACK;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('SUCCESS');
END;
/
-- Expected: should not be able to update cancellation_application when application_status is not approved yet.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        cancellation_application = 'applied'
        WHERE id = 3;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should not update row.' );
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/
-- Expected: should be able to update cancellation_application when application_status is approved.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        cancellation_application = 'applied'
        WHERE id = 88;
    counter := SQL%rowcount;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should not update row.' );
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/
-- Expected: should not be able to edit emp_id
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        emp_id = 1
        WHERE id = 88;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should not update row.' );
        ROLLBACK;
    END IF;
    ROLLBACK;
END;
/
-- Expected: Should not be able to update cancellation_status.
DECLARE
    counter INT;
BEGIN
    UPDATE SYSTEM.leaves SET 
        cancellation_status = 'approved'
        WHERE id = 86;
    counter := SQL%rowcount;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should update 0 row');
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

