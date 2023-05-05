class AccountRepository
  def get_id_user_pairs
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
end