

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
    query = "INSERT INTO accounts (name, email, username, password) VALUES ($1, $2, $3, $4)"
    params = [account.name, account.username, account.email, account.password]
    DatabaseConnection.exec_params(query, params)
  end

  def log_in(username, password)
    # Takes username/password strings as arguments
    # Returns a user object with id/name/username parameters if matched. 
    # Returns nil otherwise
    query = "SELECT id, name, username FROM accounts WHERE username = $1 AND password = $2"
    params = [username, password]
    entry = DatabaseConnection.exec_params(query, params).to_a
    return nil unless entry.length != 0
    user = Account.new(entry.first["name"], entry.first["username"])
    user.id = entry.first["id"].to_i
    p user
    return user
  end

  
end
