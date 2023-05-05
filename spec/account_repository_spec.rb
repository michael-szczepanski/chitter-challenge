require 'account_repository'

RSpec.describe AccountRepository do
  before(:each) do
    reset_database
  end

  context 'CREATE' do
    it 'creates a new entry in the database' do
      repo = AccountRepository.new
      account = double name: 'Kev', email: 'kev@kev.com', username: 'kev', password: 'kev'
      repo.create(account)
    end
  end

  context 'READ' do
    it 'returns a hash of id=>name pairs for accounts' do
      repo = AccountRepository.new
      users = repo.read_id_user_pairs
      expect(users[1]).to eq 'Anonymous'
      expect(users[2]).to eq 'Mike'
    end
  end
end
