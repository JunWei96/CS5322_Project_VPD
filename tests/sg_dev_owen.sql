-- This test file is for the user OWEN with password of OWEN.
-- OWEN is in Software Development stationed in Singapore.
-- Software Development belongs to a normal group type in the HR system.
SET ROLE NON_SYSTEM;


-- Expected: Should only return OWEN's claims.
SELECT * FROM SYSTEM.CLAIMS;