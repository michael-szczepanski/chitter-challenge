class Peep
  attr_accessor :id, :time, :content, :account_id, :tags

  def initialize(time, content, account_id)
    @time = time
    @content = content
    @account_id = account_id
    @tags = extract_tags
  end

  def extract_tags
    tags = @content.scan(/(?<=\s@)[a-zA-Z]+/).uniq
  end
end
