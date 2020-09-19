-- This test file is for the user OWEN with password of OWEN.
-- OWEN is a manager in Software Development stationed in Singapore.
-- Software Development belongs to a normal group type in the HR system.
SET ROLE NON_SYSTEM;

-- Expected: Should only return OWEN's claims plus its subordinate's claims.
SELECT C.id, C.creator, E.manager_id, C.hr_approved_by, C.finance_approved_by, C.amount, C.remark
    FROM SYSTEM.claims C 
    INNER JOIN SYSTEM.employees E 
    ON C.creator = E.id;    
    
-- Expected: Should be able to update/delete its own claims.
UPDATE SYSTEM.claims SET 
    amount = 10000
    WHERE id = 42;
DELETE SYSTEM.claims WHERE id = 42;
-- RESTORE deleted tuple.
INSERT INTO SYSTEM.claims (id,creator,hr_approved_by,finance_approved_by,amount) VALUES (42,1,14,17,5826);

-- Expected: Should not be able to update/delete other employee's records.
UPDATE SYSTEM.claims SET 
    amount = 10000
    WHERE id = 2;
DELETE SYSTEM.claims WHERE id = 2;

COMMIT;