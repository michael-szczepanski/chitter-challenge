require_relative './peep'

class PeepRepository
  def add(peep)
    # Adds a peep object to the peeps table
    # Returns id of created peep
    query = "INSERT INTO peeps (time, content, account_id, sub_peeps) VALUES ($1, $2, $3, $4)"
    params = [peep.time, peep.content, peep.account_id, peep.sub_peeps.join(",")]
    DatabaseConnection.exec_params(query, params)
    query = "SELECT max(id) FROM peeps"
    result = DatabaseConnection.exec_params(query, [])
    return result.first
  end

  def add_sub_peep(id1, id2)
    # Takes 2 integers as arguments
    # Adds id2 to the sub_peeps array of peep found at id1
    # Returns nothing
    peep = find_by_id(id1)
    peep.sub_peeps << id2 
    query = "UPDATE peeps SET sub_peeps = $1 WHERE id = $2"
    params = [peep.sub_peeps.join(","), peep.id]
    DatabaseConnection.exec_params(query, params)
  end

  def list_peeps
    # Takes no arguments
    # Returns an array of Peep objects in reverse id order
    query = "SELECT id, time, content, account_id, sub_peeps FROM peeps"
    params = []
    entries = DatabaseConnection.exec_params(query, params)
    peeps = extract_peeps(entries).sort_by(&:id).reverse
    return peeps
  end

  def find_by_id(id)
    # Takes an integer argument
    # Returns a single Peep object if id matched the database
    # Returns nil otherwise
    query = "SELECT id, time, content, account_id, sub_peeps FROM peeps WHERE id = $1"
    params = [id]
    entry = DatabaseConnection.exec_params(query, params).to_a
    return nil if entry.empty?
    peeps = extract_peeps(entry)
    return peeps.first
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
      peep.sub_peeps = entry['sub_peeps'].split(",")
      peeps << peep
    end
    return peeps
  end

end
