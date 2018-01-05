CREATE TABLE employees (
 employee_id serial PRIMARY KEY,
 full_name VARCHAR NOT NULL,
 manager_id INT
);

insert into employees values
(3,'bigboss',0),
(15,'max',3),
(27,'eric',3),
(44,'terry',27);

WITH RECURSIVE subordinates AS (
 SELECT
    employee_id,
    manager_id,
    full_name
 FROM
    employees
 WHERE
    employee_id = 27
 UNION
 SELECT
    e.employee_id,
    e.manager_id,
    e.full_name
 FROM
    employees e
 INNER JOIN subordinates s ON s.employee_id = e.manager_id
) SELECT
 *
FROM
 subordinates;
