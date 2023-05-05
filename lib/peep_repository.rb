require 'peep'

class PeepRepository
  def add(peep)
    # Adds a peep object to the peeps table
    # Returns nothing
    query = "INSERT INTO peeps (time, content, account_id) VALUES ($1, $2, $3)"
    params = [peep.time, peep.content, peep.account_id]
    DatabaseConnection.exec_params(query, params)
    return nil
  end
end