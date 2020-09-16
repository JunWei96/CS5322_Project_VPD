-- This test file is for the user XERXES with password of XERXES.
-- XERXES is a HR stationed in Singapore.
SET ROLE NON_SYSTEM;

-- Expected: Should only return the claims from all the employees in Singapore.
SELECT * FROM SYSTEM.CLAIMS;