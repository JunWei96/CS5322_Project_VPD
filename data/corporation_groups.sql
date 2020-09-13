DELETE FROM corporation_groups;

-- Oracle in SG
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (1, 1, 1, 'HR', '4080  Walnut Street');
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (2, 1, 1, 'Finance', '4080  Walnut Street');
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (3, 1, 1, 'Auditor', '4080  Walnut Street');
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (4, 1, 1, 'Software Development', '4080  Walnut Street');
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (5, 1, 1, 'Research', '4080  Walnut Street');

-- Oracle in US
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (6, 1, 1, 'HR', '3400  Canis Heights Drive');
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (7, 1, 2, 'Auditor', '3400  Canis Heights Drive');
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (8, 1, 2, 'Finance', '3400  Canis Heights Drive');
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (9, 1, 1, 'Research', '3400  Canis Heights Drive');

SELECT * FROM corporation_groups;