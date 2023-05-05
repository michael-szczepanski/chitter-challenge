require 'peep'

RSpec.describe Peep do
  it 'creates a new object' do
    peep = Peep.new(Time.now, 'henlo', 1)
    expect(peep.content).to eq 'henlo'
    expect(peep.account_id).to eq 1
  end
end