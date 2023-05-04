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
  tag: int (referencing Account id)

#### Repository classes:

AccountRepository

PeepRepository
