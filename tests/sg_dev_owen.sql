-- This test file is for the user OWEN with password of OWEN.
-- OWEN is a manager in Software Development stationed in Singapore.
-- Software Development belongs to a normal group type in the HR system.
SET ROLE NON_SYSTEM;


-- Expected: Should only return OWEN's claims plus its subordinate's claims.
SELECT C.creator, E.manager_id, C.hr_approved_by, C.finance_approved_by, C.amount, C.remark
    FROM SYSTEM.claims C 
    INNER JOIN SYSTEM.employees E 
    ON C.creator = E.id;