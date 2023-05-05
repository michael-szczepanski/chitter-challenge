require 'peep_repository'

RSpec.describe PeepRepository do
  before(:each) do
    reset_database
  end

  context 'CREATE' do
    it 'adds a new Peep to database' do
      repo = PeepRepository.new
      peep = double time: '2023-05-05 11:53:11', content: 'henlo', account_id: 1
      repo.add(peep)
      peeps = repo.list_peeps
      expect(peeps.first.time).to eq Time.parse('2023-05-05 11:53:11')
      expect(peeps.first.content).to eq 'henlo'
      expect(peeps.first.account_id).to eq 1
    end
  end

  context 'READ' do
    it 'returns a reverse ordered list of peeps' do
      repo = PeepRepository.new
      peeps = repo.list_peeps
      expect(peeps.last.id).to eq 1
      expect(peeps.last.time).to eq Time.parse('2023-05-04 12:45:12')
      expect(peeps.last.content).to eq 'Mikes peep'
      expect(peeps.last.account_id).to eq 2
    end
  end
end
