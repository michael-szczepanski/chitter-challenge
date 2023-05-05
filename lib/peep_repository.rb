require_relative './peep'

class PeepRepository
  def add(peep)
    # Adds a peep object to the peeps table
    # Returns nothing
    query = "INSERT INTO peeps (time, content, account_id) VALUES ($1, $2, $3)"
    params = [peep.time, peep.content, peep.account_id]
    DatabaseConnection.exec_params(query, params)
    return nil
  end

  def list_peeps
    # Takes no arguments
    # Returns an array of Peep objects in reverse id order
    query = "SELECT id, time, content, account_id FROM peeps"
    params = []
    entries = DatabaseConnection.exec_params(query, params)
    peeps = extract_peeps(entries)
    return peeps.reverse
  end

  private 
  
  def extract_peeps(entries)
    peeps = []
    for entry in entries do
      time = Time.parse(entry['time'])
      content = entry['content']
      account_id = entry['account_id'].to_i
      peep = Peep.new(time, content, account_id)
      peep.id = entry['id'].to_i
      peeps << peep
    end
    return peeps
  end

end
