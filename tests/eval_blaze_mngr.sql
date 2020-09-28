-- This test file is for the user BLAZE  with password of BLAZE.
-- BLAZE is a Manager stationed in Singapore.
CONNECT BLAZE/BLAZE
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
