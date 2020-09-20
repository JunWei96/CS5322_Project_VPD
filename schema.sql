CREATE TABLE employees (
  id int PRIMARY KEY,
  manager_id int,
  job_id int,
  corporation_group_id int,
  slug varchar(30) UNIQUE,
  full_name varchar(30),
  date_of_birth date,
  email varchar(50),
  start_date date
);

CREATE TABLE employees_sensitive_data (
  id int PRIMARY KEY,
  address varchar(255),
  phone varchar(50),
  salary int,
  biography varchar(255)
);

CREATE TABLE credentials (
  id int PRIMARY KEY,
  employee_id int UNIQUE,
  hashed_password varchar(255),
  salt varchar(50),
  session_token varchar(100),
  session_expriy date
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
  start_date date,
  end_date date,
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

CREATE TABLE locations (
  id int PRIMARY KEY,
  country_id int,
  address varchar(255),
  postal_code varchar(100),
  city varchar(100)
);

CREATE TABLE corporation_groups (
  id int PRIMARY KEY,
  parent_group_id int,
  location_id int,
  name varchar(100),
  group_type varchar(20) DEFAULT 'normal' check (group_type in ('normal', 'hr', 'auditor', 'finance'))
);

CREATE TABLE jobs (
  id int PRIMARY KEY,
  job_title varchar(100),
  min_salary int,
  max_salary int
);

CREATE TABLE job_history (
  employee_id int,
  job_id int,
  start_date date,
  end_date date
);

ALTER TABLE employees ADD FOREIGN KEY (manager_id) REFERENCES employees (id);

ALTER TABLE employees ADD FOREIGN KEY (job_id) REFERENCES jobs (id);

ALTER TABLE employees ADD FOREIGN KEY (corporation_group_id) REFERENCES corporation_groups (id);

ALTER TABLE employees_sensitive_data ADD FOREIGN KEY (id) REFERENCES employees (id);

ALTER TABLE credentials ADD FOREIGN KEY (employee_id) REFERENCES employees (id);

ALTER TABLE past_credentials ADD FOREIGN KEY (current_credential) REFERENCES credentials (id);

ALTER TABLE leaves ADD FOREIGN KEY (emp_id) REFERENCES employees (id);

ALTER TABLE evaluations ADD FOREIGN KEY (author) REFERENCES employees (id);

ALTER TABLE evaluations ADD FOREIGN KEY (recipient) REFERENCES employees (id);

ALTER TABLE claims ADD FOREIGN KEY (creator) REFERENCES employees (id);

ALTER TABLE claims ADD FOREIGN KEY (hr_approved_by) REFERENCES employees (id);

ALTER TABLE claims ADD FOREIGN KEY (finance_approved_by) REFERENCES employees (id);

ALTER TABLE payslips ADD FOREIGN KEY (recipient) REFERENCES employees (id);

ALTER TABLE locations ADD FOREIGN KEY (country_id) REFERENCES countries (id);

ALTER TABLE corporation_groups ADD FOREIGN KEY (parent_group_id) REFERENCES corporation_groups (id);

ALTER TABLE corporation_groups ADD FOREIGN KEY (location_id) REFERENCES locations (id);

ALTER TABLE job_history ADD FOREIGN KEY (employee_id) REFERENCES employees (id);

ALTER TABLE job_history ADD FOREIGN KEY (job_id) REFERENCES jobs (id);
