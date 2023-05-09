require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/database_connection'
require_relative './lib/peep'
require_relative './lib/peep_repository'
require_relative './lib/account_repository'
require_relative './lib/account'

DatabaseConnection.connect

class Chitter < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
    enable :sessions
    # also_reload lib/peep_repository
    # also_reload lib/account_repository
  end

  get '/' do
    peep_repo = PeepRepository.new
    account_repo = AccountRepository.new
    session[:user] = AccountRepository.new.find_by_id(1) if session[:user].nil?
    @peeps = peep_repo.list_peeps
    @accounts = account_repo.read_id_user_pairs
    @user = session[:user]
    
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
    content = params[:content].gsub(/[<>]/, "")
    peep = Peep.new(time, content, session[:user].nil? ? 1 : session[:user].id)
    peep_repo.add(peep)

    redirect '/'
  end

  post '/new_user' do
    account_repo = AccountRepository.new
    username = params[:username].gsub(/[<>]/, "")
    email = params[:email].gsub(/[<>]/, "")
    if account_repo.username_is_unique?(username) && account_repo.email_is_unique?(email)
      name = params[:name].gsub(/[<>]/, "")
      password = params[:password].gsub(/[<>]/, "")
      @account = Account.new(name, email, username, password)
      account_repo.create(@account)
      session[:user] = account_repo.log_in(username, password)
      erb(:new_user_created)
    else
      status 400
      erb(:sign_up_failed)      
    end
  end

  post '/log_in' do
    account_repo = AccountRepository.new
    username = params[:username].gsub(/[<>]/, "")
    password = params[:password].gsub(/[<>]/, "")
    session[:user] = account_repo.log_in(username, password)
    redirect '/'
  end

  post '/log_out' do
    session[:user] = AccountRepository.new.find_by_id(1)
    redirect '/'
  end

end
