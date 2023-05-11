require_relative './peep_repository'
require_relative './account_repository'

class ListHelper

  def gen_peep_list(peeps, tab_size)
    # Takes an array of peep objects
    # Generates a html string representation of the list of peeps and sub peeps
    # Returns a string
    html = ""
    tab = "&ensp;" * tab_size
    for peep in peeps do
      next if sub_peep?(peep, peeps)
      html << peep_string(peep, tab_size)
      html << gen_sub_peep_list(peep.sub_peeps, tab_size) unless peep.sub_peeps.empty?
    end
    return html
  end

  private

  def sub_peep?(peep, peeps)
    # Iterates through peeps array and returns true if peep.id is found
    # in any of the peep.sub_peeps arrays
    # Returns false otherwise
    for entry in peeps
      return true if entry.sub_peeps.include?(peep.id.to_s)
    end
    return false
  end
  
  def gen_sub_peep_list(peep_ids, tab_size)
    html = ""
    tab_size += 4
    tab = "&ensp;" * tab_size
    for peep_id in peep_ids do
      repo = PeepRepository.new
      peep = repo.find_by_id(peep_id)
      html << peep_string(peep, tab_size)
      html << gen_sub_peep_list(peep.sub_peeps, tab_size) unless peep.sub_peeps.empty?
    end
    return html
  end
  
  def peep_string(peep, tab_size)
    tab = "&ensp;" * tab_size 
    repo = AccountRepository.new
    return "#{tab}<div class='simpleborder'>
      #{repo.find_by_id(peep.account_id)} on #{peep.time.strftime("%d/%m/%Y at %k:%M")}<br><br>
      #{peep.content}<br><br>
      <form action='/reply_to' method='POST'>
      <input type='hidden' name='id' value=#{peep.id}>
      <input type='text' name='content' placeholder='Reply to this peep'
      oninvalid='alert('You must write something to post it')' required>
      <input type='submit' value='Submit'/></form></div><br>"
  end

end
