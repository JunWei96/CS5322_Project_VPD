-- This test file is for the user XERXES with password of XERXES.
-- XERXES is a HR stationed in Singapore.
CONNECT XERXES/XERXES;
SET ROLE NON_SYSTEM, HR;

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
