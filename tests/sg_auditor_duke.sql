-- This test file is for the user DUKE with password of DUKE.
-- DUKE is an auditor stationed in Singapore.
SET ROLE NON_SYSTEM;

-- Expected: Should only return the claims from all the employees in Singapore.
SELECT C.id, C.creator, E.manager_id, C.hr_approved_by, C.finance_approved_by, C.amount, C.remark
    FROM SYSTEM.claims C 
    INNER JOIN SYSTEM.employees E 
    ON C.creator = E.id;

-- Expected: Should be able to update/delete its own claims.
UPDATE SYSTEM.claims SET 
    amount = 10000
    WHERE id = 17;
DELETE SYSTEM.claims WHERE id = 17;
-- RESTORE deleted tuple.
INSERT INTO SYSTEM.claims (id,creator,hr_approved_by,finance_approved_by,amount) VALUES (17,4,NULL,19,7393);

-- Expected: Should not be able to update/delete other employee's records.
UPDATE SYSTEM.claims SET 
    amount = 10000
    WHERE id = 2;
DELETE SYSTEM.claims WHERE id = 2;

ROLLBACK;