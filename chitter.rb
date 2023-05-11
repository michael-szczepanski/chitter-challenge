require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require_relative './lib/list_helper'
require_relative './lib/database_connection'
require_relative './lib/peep'
require_relative './lib/peep_repository'
require_relative './lib/account_repository'
require_relative './lib/account'

DatabaseConnection.connect

class Chitter < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
    register Sinatra::Flash
  end

  get '/' do
    list_helper = ListHelper.new
    peep_repo = PeepRepository.new
    account_repo = AccountRepository.new
    session[:user] = AccountRepository.new.find_by_id(1) if session[:user].nil?
    peeps = peep_repo.list_peeps
    @accounts = account_repo.read_id_user_pairs
    @user = session[:user]
    @peeps = list_helper.gen_peep_list(peeps, 1)
    
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
    peep = Peep.new(time, content, session[:user].nil? ? 1 : session[:user].id)
    peep_repo.add(peep)

    redirect '/'
  end

  post '/reply_to' do
    peep_repo = PeepRepository.new
    time = Time.now
    content = params[:content]
    peep = Peep.new(time, content, session[:user].nil? ? 1 : session[:user].id)
    id = peep_repo.add(peep)["max"].to_i
    peep_repo.add_sub_peep(params[:id], id)
    redirect '/'
  end

  post '/new_user' do
    account_repo = AccountRepository.new
    username = params[:username]
    email = params[:email]
    username_valid = account_repo.username_is_valid?(username)
    email_valid = account_repo.email_is_valid?(email)
    
    if username_valid && email_valid
      name = params[:name]
      password = params[:password]
      @account = Account.new(name, username, email, password)
      account_repo.create(@account)
      session[:user] = account_repo.log_in(username, password)
      return erb(:new_user_created)
    else
      flash[:username] = "Username is already in use" unless username_valid
      flash[:email] = "This email is already in use" unless email_valid
      redirect '/sign_up'
    end
  end

  post '/log_in' do
    account_repo = AccountRepository.new
    username = params[:username]
    password = params[:password]
    session[:user] = account_repo.log_in(username, password)
    if session[:user].nil?
      flash[:failed] = "Incorrect username/password"
      redirect '/log_in'
    else
      redirect '/'
    end
  end

  post '/log_out' do
    session[:user] = AccountRepository.new.find_by_id(1)
    redirect '/'
  end

end
