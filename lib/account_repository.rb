class AccountRepository
  
  def read_id_user_pairs
    # Takes no arguments
    # Returns a hash of id=>name pairs for accounts
    query = "SELECT id, name FROM accounts"
    params = []
    entries = DatabaseConnection.exec_params(query, params)
    users = {}
    for user in entries
      key = user['id'].to_i
      value = user['name']
      users[key] = value
    end
    return users
  end

  def create(account)
    # Takes an Account object as an argument
    # Adds the relevant object into the database
    # Returns nothing
    query = "INSERT INTO accounts (name, email, username, password) VALUES ($1, $2, $3, $4)"
    params = [account.name, account.email, account.username, account.password]
    DatabaseConnection.exec_params(query, params)
  end
  
end
