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
      expect(users[1]).to eq 'Anonymous (anon)'
      expect(users[2]).to eq 'Mike (mike)'
    end

    it 'returns a user provided a correct username/password' do
      repo = AccountRepository.new
      account = double name: 'Kev', email: 'kev@kev.com', username: 'kev', password: 'kevin'
      repo.create(account)
      user = repo.log_in('kev', 'kevin')
      expect(user.name).to eq 'Kev'
      expect(user.username).to eq 'kev'
      expect(user.id).to eq 4
    end

    it 'returns a single user by id provided' do
      repo = AccountRepository.new
      user = repo.find_by_id(1)
      expect(user.name).to eq 'Anonymous'
      expect(user.id).to eq 1
      expect(user.username).to eq 'anon'
    end

    it 'checks if username is valid' do
      repo = AccountRepository.new
      expect(repo.username_is_valid?('mike')).to eq false
      expect(repo.username_is_valid?('kevin')).to eq true
    end

    it 'checks if email is unique' do
      repo = AccountRepository.new
      expect(repo.email_is_valid?('mike@mike.mike')).to eq false
      expect(repo.email_is_valid?('hh4@gmail.com')).to eq true
    end
  end
end
