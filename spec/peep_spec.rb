require 'peep'

RSpec.describe Peep do
  before(:each) do
    reset_database
  end

  it 'creates a new object' do
    peep = Peep.new(Time.now, 'henlo', 1)
    expect(peep.content).to eq 'henlo'
    expect(peep.account_id).to eq 1
  end

  it 'retrieves tags from content' do
    peep = Peep.new(Time.now, "@michael is having a great time with @ruby. @michael", 1)
    expect(peep.tags.size).to eq 2
    expect(peep.tags).to include 'michael'
    expect(peep.tags).to include 'ruby'
  end
end
