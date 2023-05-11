require 'peep_repository'

RSpec.describe PeepRepository do
  before(:each) do
    reset_database
  end

  context 'CREATE' do
    it 'adds a new Peep to database' do
      repo = PeepRepository.new
      peep = double time: '2023-05-05 11:53:11', content: 'henlo', account_id: 1, sub_peeps: []
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
      expect(peeps.last.tags).to eq []
    end

    it 'returns a single peep with correct id' do
      repo = PeepRepository.new
      peep = repo.find_by_id(1)
      expect(peep.id).to eq 1
      expect(peep.time).to eq Time.parse('2023-05-04 12:45:12')
      expect(peep.content).to eq 'Mikes peep'
      expect(peep.account_id).to eq 2
      expect(peep.tags).to eq []
      expect(peep.sub_peeps).to eq []
    end
  end

  context 'UPDATE' do
    it 'adds a sub_peep to entry' do
      repo = PeepRepository.new
      repo.add_sub_peep(1, 2)
      repo.add_sub_peep(1, 3)
      peep = repo.find_by_id(1)
      expect(peep.sub_peeps).to eq ['2', '3']
    end
  end
end
