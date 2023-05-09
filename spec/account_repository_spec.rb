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
    repo = AccountRepository.new
    it 'returns a hash of id=>name pairs for accounts' do
      users = repo.read_id_user_pairs
      expect(users[1]).to eq 'Anonymous (anon)'
      expect(users[2]).to eq 'Mike (mike)'
    end

    it 'returns a user provided a correct username/password' do
      user = repo.log_in('mike', 'mike1')
      expect(user.name).to eq 'Mike'
      expect(user.username).to eq 'mike'
      expect(user.id).to eq 2
    end

    it 'returns a single user by id provided' do
      user = repo.find_by_id(1)
      expect(user.name).to eq 'Anonymous'
      expect(user.id).to eq 1
      expect(user.username).to eq 'anon'
    end

    it 'checks if username is unique' do
      expect(repo.username_is_unique?('mike')).to eq false
      expect(repo.username_is_unique?('kevin')).to eq true
    end

    it 'checks if email is unique' do
      expect(repo.email_is_unique?('mike@mike.mike')).to eq false
      expect(repo.email_is_unique?('hi')).to eq true
    end
  end
end
