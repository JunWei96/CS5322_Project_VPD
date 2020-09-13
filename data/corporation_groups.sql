DELETE FROM corporation_groups;

-- Oracle in SG
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (1, 1, 1, 'finance', '4080  Walnut Street');
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (2, 1, 1, 'auditor', '4080  Walnut Street');

-- Oracle in US
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (3, 1, 2, 'auditor', '3400  Canis Heights Drive');
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (4, 1, 2, 'finance', '3400  Canis Heights Drive');


SELECT * FROM corporation_groups;