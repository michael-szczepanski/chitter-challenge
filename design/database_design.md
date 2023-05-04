chitter_challenge

table: accounts
id: SERIAL
email: regex_string (checks for @ and domain)
password: text
name: text
username: text

table: peeps
id: SERIAL
time: date
content: text
account_id: FOREIGN KEY > accounts_id