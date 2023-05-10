require 'bcrypt'

class AccountRepository
  
  def read_id_user_pairs
    # Takes no arguments
    # Returns a hash of id=>'name (username)' pairs for accounts
    query = "SELECT id, name, username FROM accounts"
    params = []
    entries = DatabaseConnection.exec_params(query, params)
    users = {}
    for user in entries
      key = user['id'].to_i
      value = "#{user['name']} (#{user['username']})"
      users[key] = value
    end
    return users
  end

  def create(account)
    # Takes an Account object as an argument
    # Adds the relevant object into the database
    # Returns nothing
    encrypted_password = BCrypt::Password.create(account.password)

    query = "INSERT INTO accounts (name, username, email, password) VALUES ($1, $2, $3, $4)"
    params = [account.name, account.username, account.email, encrypted_password]
    DatabaseConnection.exec_params(query, params)
  end

  def log_in(username, password)
    # Takes username/password strings as arguments
    # Returns a user object with id/name/username parameters if matched. 
    # Returns nil otherwise
    query = "SELECT id, name, username, password FROM accounts WHERE username = $1"
    params = [username]
    entry = DatabaseConnection.exec_params(query, params).to_a
    return nil if entry.empty?
    stored_password = BCrypt::Password.new(entry.first["password"])
    return nil unless stored_password == password
    user = Account.new(entry.first["name"], entry.first["username"])
    user.id = entry.first["id"].to_i
    return user
  end

  def find_by_id(id)
    # Takes an integer as an argument
    # Returns an account object if id is found in database
    # Returns nil otherwise
    query = "SELECT id, name, username FROM accounts WHERE id = $1"
    params = [id]
    entry = DatabaseConnection.exec_params(query, params).to_a
    return nil if entry.empty?
    user = Account.new(entry.first["name"], entry.first["username"])
    user.id = entry.first["id"].to_i
    return user
  end

  def username_is_unique?(username)
    # Takes a string as an argument
    # Returns true if no entries with that username have been found
    # Returns false otherwise
    query = "SELECT id FROM accounts WHERE username=$1"
    params = [username]
    entries = DatabaseConnection.exec_params(query, params).to_a
    return entries.empty?
  end

  def email_is_unique?(email)
    # Takes a string as an argument
    # Returns true if no entries with that email have been found
    # Returns false otherwise
    query = "SELECT id FROM accounts WHERE email=$1"
    params = [email]
    entries = DatabaseConnection.exec_params(query, params).to_a
    return entries.empty?
  end
end
