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
end