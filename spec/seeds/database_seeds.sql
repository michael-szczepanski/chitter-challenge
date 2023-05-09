DROP TABLE IF EXISTS accounts, peeps;

CREATE TABLE IF NOT EXISTS accounts (
  id SERIAL PRIMARY KEY,
  email text,
  password text,
  name text,
  username text
);

CREATE TABLE IF NOT EXISTS peeps (
  id SERIAL PRIMARY KEY,
  time timestamp,
  content text,
  account_id int,
  constraint fk_accounts foreign key(account_id) references accounts(id) on delete cascade
);

TRUNCATE TABLE accounts, peeps;

INSERT INTO accounts
(name, username, email, password) VALUES
('Anonymous', 'anon', NULL, NULL),
('Mike', 'mike', 'mike@mike.com', 'mike1'),
('Ruby', 'ruby', 'ruby@ruby.ruby', 'ruby1');

INSERT INTO peeps
(time, content, account_id) VALUES
('2023-05-04 12:45:12', 'Mikes peep', 2),
('2023-05-05 11:55:43', 'Rubys peep', 3);