DELETE FROM corporation_groups;

-- Oracle in Singapore
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (1, 1, 1, 'audit', '4080  Walnut Street');
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (2, 1, 1, 'finance', '4080  Walnut Street');

-- Oracle in Taiwan
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (3, 1, 2, 'audit', '3400  Canis Heights Drive');
INSERT INTO corporation_groups (id, corporation_id, country, name, adresss) 
    VALUES (4, 1, 2, 'finance', '3400  Canis Heights Drive');


SELECT * FROM corporation_groups;