DROP TABLE IF EXISTS accounts, peeps;

CREATE TABLE IF NOT EXISTS accounts (
  id SERIAL PRIMARY KEY,
  email text,
  password text,
  name text,
  username text,
);

CREATE TABLE IF NOT EXISTS peeps (
  id SERIAL PRIMARY KEY,
  time date,
  content text,
  account_id int,
  constraint fk_accounts foreign key(account_id) reference accounts(id) on delete cascade
);

INSERT INTO accounts
(name, username, email, password) VALUES
;

INSERT INTO peeps
(time, content, account_id) VALUES
;