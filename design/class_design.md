Nouns: peep, chitter, chronology (date), time, Account?
Verbs: post_peep, see_peeps, see_peep_time, sign_up, log_in, log_out, send_email

#### Main class:

Application:
  def: log_in
  def: log_out
  def: sign_up
  def: see_peeps
  def: post_peep
  def: send_email

  

#### Model classes:

Account:
  id: Int
  email: String
  password: String
  name: String
  username: String

Peep:
  id: Int
  time: Date
  content: String
  account_id: int (referencing Account id)
  peeps: Array (array of sub peeps)


#### Repository classes:

AccountRepository
  read_id_user_pairs
    # returns id=>username pairs
  create(account)
    # adds a new account object to database
  log_in(username, password)
    # checks if username/password combo exists in database
  find_by_id(id)
  username is valid?(username)
    # checks if username is avaialble for signup
  email_is_valid?(email)
    # checks if email is available for signup

PeepRepository
  add(peep)
    # adds a new peep to the database
  list_peeps
    # lists all peeps from database
