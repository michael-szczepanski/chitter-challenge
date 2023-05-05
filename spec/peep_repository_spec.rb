require 'peep_repository'

RSpec.describe PeepRepository do
  before(:each) do
    reset_database
  end

  context 'CREATE' do
    it 'adds a new Peep to database' do
      repo = PeepRepository.new
      peep = double time:'2023-05-05 11:53:11', content:'henlo', account_id:1
      repo.add(peep)
      peeps = repo.list_peeps
      expect(peeps.last.time).to eq '2023-05-05 11:53:11'
      expect(peeps.last.content).to eq 'henlo'
      expect(peeps.last.account_id).to eq 1
    end
  end
end