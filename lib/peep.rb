class Peep
  attr_accessor :id, :time, :content, :account_id

  def initialize(time, content, account_id)
    @time = time
    @content = content
    @account_id = account_id
  end
end