-- This test file is for the user STAFFORD with password of STAFFORD.
-- STAFFORD is in finance stationed in Singapore.
SET ROLE NON_SYSTEM;

-- Expected: Should only return the claims from all the employees in Singapore.
SELECT C.creator, E.manager_id, C.hr_approved_by, C.finance_approved_by, C.amount, C.remark
    FROM SYSTEM.claims C 
    INNER JOIN SYSTEM.employees E 
    ON C.creator = E.id;