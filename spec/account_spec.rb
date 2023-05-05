require 'account'

RSpec.describe Account do
  it 'creates a new account' do
    account = Account.new('Kevin', 'kevin@kevin.com', 'kevin', 'kevin')
    expect(account.name).to eq 'Kevin'
    expect(account.email).to eq 'kevin@kevin.com'
    expect(account.username).to eq 'kevin'
  end
end
