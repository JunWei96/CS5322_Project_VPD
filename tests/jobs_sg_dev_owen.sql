-- This test file is for the user OWEN with password of OWEN.
-- OWEN is a manager in Software Development stationed in Singapore.
-- Software Development belongs to a normal group type in the HR system.
CONNECT OWEN/OWEN;
SET ROLE NON_SYSTEM, MANAGER;

-- Expected: should not be able to see min salary.
DECLARE
    counter INT;
BEGIN
    SELECT DISTINCT COUNT(min_salary)
        INTO counter
        FROM SYSTEM.jobs J;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of min salaries.');
    END IF;
END;
/
-- Expected: should not be able to see max salary.
DECLARE
    counter INT;
BEGIN
    SELECT DISTINCT COUNT(max_salary)
        INTO counter
        FROM SYSTEM.jobs J;
    IF counter != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Incorrect number of max salaries.');
    END IF;
END;