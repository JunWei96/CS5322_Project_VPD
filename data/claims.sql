DELETE FROM claims;

INSERT INTO claims (id,creator,hr_approved_by,finance_approved_by,amount) VALUES (1,1,null,null,1000);
INSERT INTO claims (id,creator,hr_approved_by,finance_approved_by,amount) VALUES (2,2,null,null,200);
INSERT INTO claims (id,creator,hr_approved_by,finance_approved_by,amount) VALUES (3,3,null,null,10000);
INSERT INTO claims (id,creator,hr_approved_by,finance_approved_by,amount) VALUES (4,4,null,null,1234);
INSERT INTO claims (id,creator,hr_approved_by,finance_approved_by,amount) VALUES (5,5,null,null,4213);
INSERT INTO claims (id,creator,hr_approved_by,finance_approved_by,amount) VALUES (6,6,null,null,41233);

SELECT * FROM claims;