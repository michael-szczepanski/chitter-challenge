class Account
  attr_accessor :id, :name, :email, :username, :password

  def initialize(name, username, email = '', password = '')
    @name = name
    @email = email
    @username = username
    @password = password
  end

end
