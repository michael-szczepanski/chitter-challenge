require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/database_connection'
require_relative './lib/peep'
require_relative './lib/peep_repository'
require_relative './lib/account_repository'
require_relative './lib/account'

DatabaseConnection.connect

class Chitter < Sinatra::Base

  # @user = Account.new('Anonymous', 'anon')

  # def initialize
  #   super()
  #   @user = 0
  # end

  configure :development do
    register Sinatra::Reloader
    enable :sessions
    # also_reload lib/peep_repository
    # also_reload lib/account_repository
  end

  get '/' do
    peep_repo = PeepRepository.new
    account_repo = AccountRepository.new
    if session[:user].nil?
      session[:user] = AccountRepository.new.find_by_id(1)
    end
    @peeps = peep_repo.list_peeps
    @accounts = account_repo.read_id_user_pairs
    
    return erb(:main_page)
  end

  get '/sign_up' do
    erb(:sign_up_page)
  end

  get '/log_in' do
    erb(:log_in_page)
  end

  post '/new_peep' do
    peep_repo = PeepRepository.new
    time = Time.now
    content = params[:content]
    peep = Peep.new(time, content, session[:user].id == nil ? 1 : session[:user].id)
    peep_repo.add(peep)

    redirect '/'
  end

  post '/new_user' do
    account_repo = AccountRepository.new
    @account = Account.new(params[:name], params[:email], params[:username], params[:password])
    account_repo.create(@account)

    erb(:new_user_created)
  end

  post '/log_in' do
    account_repo = AccountRepository.new
    session[:user] = account_repo.log_in(params[:username], params[:password])
    redirect '/'
  end

  post '/log_out' do
    session[:user] = AccountRepository.new.find_by_id(1)
    redirect '/'
  end
end
