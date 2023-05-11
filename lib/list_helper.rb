require_relative './peep_repository'

module ListHelper
  def generate_peep_list(peeps, tab_size="")
    # Takes an array of peep objects
    # Generates a html string representation of the list of peeps and sub peeps
    # Returns a string
    tab = "" * tab_size
    for peep in peeps do
      html = peep_string(peep, tab)
      if !peep.sub_peeps.empty?
        for sub_peep_id in peep.sub_peeps do
          repo = PeepRepository.new
          html << peep_string(repo.find_by_id(sub_peep_id), tab_size + 4)
          peeps.delete_id { |peep| peep.id = sub_peep_id }
        end
      end
    end 
  end

  private 
  
  def peep_string(peep, tab)
    html = ""
    html << "#{tab}<span><%= #{peep.time} %></span><br>"
    html << "#{tab}<span class='simpleborder'><%= @accounts[#{peep.account_id}] %></span><br>"
    html << "#{tab}<div class='simpleborder'>#{peep.content}</div>"
    html << "#{tab}<form action='/reply_to' method='POST'>"
    html << "#{tab}<input type='hidden' name='id' value=#{peep.id}>"
    html << "#{tab}<input type='text' name='content' placeholder='Reply to this peep'"
    html << "#{tab}oninvalid='alert('You must write something to post it')' required>"
    html << "#{tab}<input type='submit' value='Submit'/>"
    html << "#{tab}</form>"
    return html
end