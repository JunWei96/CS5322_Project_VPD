CREATE TABLE employees (
  id int PRIMARY KEY,
  manager_id int,
  job_id int,
  slug varchar(30) UNIQUE,
  full_name varchar(30),
  date_of_birth timestamp,
  address varchar(255),
  phone varchar(50),
  email varchar(50),
  salary int,
  start_date timestamp,
  biography varchar(255)
);

CREATE TABLE credentials (
  id int PRIMARY KEY,
  employee_id int,
  hashed_password varchar(255),
  salt varchar(50),
  session_token varchar(100),
  session_expriy timestamp
);

CREATE TABLE past_credentials (
  id int PRIMARY KEY,
  current_credential int,
  hashed_password varchar(255),
  salt varchar(50)
);

CREATE TABLE leaves (
  id int PRIMARY KEY,
  emp_id int,
  leave_type varchar(20) not null check (leave_type in ('mc', 'annual_leave', 'compassionate_leave')),
  start_date timestamp,
  end_date timestamp,
  status varchar(20) not null check (status in ('not_applied', 'applied', 'approved', 'rejected', 'obselete')),
  remark varchar(255)
);

CREATE TABLE evaluations (
  id int PRIMARY KEY,
  author int,
  recipient int,
  notes varchar(255)
);

CREATE TABLE claims (
  id int PRIMARY KEY,
  creator int,
  hr_approved_by int,
  finance_approved_by int,
  amount int,
  remark varchar(255)
);

CREATE TABLE payslips (
  id int PRIMARY KEY,
  recipient int,
  amount_paid int
);

CREATE TABLE countries (
  id int PRIMARY KEY,
  name varchar(100),
  country_code varchar(10)
);

CREATE TABLE corporations (
  id int PRIMARY KEY,
  name varchar(100)
);

CREATE TABLE corporation_groups (
  id int PRIMARY KEY,
  corporation_id int,
  parent_group_id int,
  country int,
  name varchar(100),
  adresss varchar(255)
);

CREATE TABLE corporation_groups_employees (
  employee_id int,
  corporation_group_id int
);

CREATE TABLE jobs (
  id int PRIMARY KEY,
  corporation_group_id int,
  job_title varchar(100),
  min_salary int,
  max_salary int
);

CREATE TABLE job_history (
  employee_id int,
  job_id int,
  start_date timestamp,
  end_date timestamp
);

ALTER TABLE employees ADD FOREIGN KEY (manager_id) REFERENCES employees (id);

ALTER TABLE employees ADD FOREIGN KEY (job_id) REFERENCES jobs (id);

ALTER TABLE credentials ADD FOREIGN KEY (employee_id) REFERENCES employees (id);

ALTER TABLE past_credentials ADD FOREIGN KEY (current_credential) REFERENCES credentials (id);

ALTER TABLE leaves ADD FOREIGN KEY (emp_id) REFERENCES employees (id);

ALTER TABLE evaluations ADD FOREIGN KEY (author) REFERENCES employees (id);

ALTER TABLE evaluations ADD FOREIGN KEY (recipient) REFERENCES employees (id);

ALTER TABLE claims ADD FOREIGN KEY (creator) REFERENCES employees (id);

ALTER TABLE claims ADD FOREIGN KEY (hr_approved_by) REFERENCES employees (id);

ALTER TABLE claims ADD FOREIGN KEY (finance_approved_by) REFERENCES employees (id);

ALTER TABLE payslips ADD FOREIGN KEY (recipient) REFERENCES employees (id);

ALTER TABLE corporation_groups ADD FOREIGN KEY (corporation_id) REFERENCES corporations (id);

ALTER TABLE corporation_groups ADD FOREIGN KEY (parent_group_id) REFERENCES corporation_groups (id);

ALTER TABLE corporation_groups ADD FOREIGN KEY (country) REFERENCES countries (id);

ALTER TABLE corporation_groups_employees ADD FOREIGN KEY (employee_id) REFERENCES employees (id);

ALTER TABLE corporation_groups_employees ADD FOREIGN KEY (corporation_group_id) REFERENCES corporation_groups (id);

ALTER TABLE jobs ADD FOREIGN KEY (corporation_group_id) REFERENCES corporation_groups (id);

ALTER TABLE job_history ADD FOREIGN KEY (employee_id) REFERENCES employees (id);

ALTER TABLE job_history ADD FOREIGN KEY (job_id) REFERENCES jobs (id);
