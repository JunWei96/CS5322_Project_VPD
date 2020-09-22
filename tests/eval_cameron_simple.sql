--This test is for CAMERON a low level employee
CONNECT CAMERON/CAMERON;
SET ROLE NON_SYSTEM;

--This is to check what evaluation cameron has access to.
--Expected: should only return one entry

DECLARE
    counter INT;
BEGIN
    SELECT COUNT(*) INTO counter FROM SYSTEM.evaluations;
    IF counter != 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Should return 1 evaluation.');
    END IF;
    ROLLBACK;
END;