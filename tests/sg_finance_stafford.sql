-- This test file is for the user STAFFORD with password of STAFFORD.
-- STAFFORD is in finance stationed in Singapore.
SET ROLE NON_SYSTEM;

-- Expected: Should only return the claims from all the employees in Singapore.
SELECT C.id, C.creator, E.manager_id, C.hr_approved_by, C.finance_approved_by, C.amount, C.remark
    FROM SYSTEM.claims C 
    INNER JOIN SYSTEM.employees E 
    ON C.creator = E.id;

-- Expected: Should be able to update/delete claims from employee in Singapore.
UPDATE SYSTEM.claims SET 
    amount = 10000
    WHERE id = 42;
DELETE SYSTEM.claims WHERE id = 42;
-- RESTORE deleted tuple.
INSERT INTO SYSTEM.claims (id,creator,hr_approved_by,finance_approved_by,amount) VALUES (42,1,14,17,5826);

-- Expected: Should not be able to update/delete employee's from other country.
UPDATE SYSTEM.claims SET 
    amount = 10000
    WHERE id = 44;
DELETE SYSTEM.claims WHERE id = 44;

COMMIT;