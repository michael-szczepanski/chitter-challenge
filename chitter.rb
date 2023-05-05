require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/database_connection'
require_relative './lib/peep'
require_relative './lib/peep_repository'
require_relative './lib/account_repository'

DatabaseConnection.connect

class Chitter < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
    # also_reload lib/peep_repository
    # also_reload lib/account_repository
    set :test, false # settings.test to access variable
    set :user_id, 1
  end

  get '/' do
    peep_repo = PeepRepository.new
    account_repo = AccountRepository.new
    @peeps = peep_repo.list_peeps
    @accounts = account_repo.read_id_user_pairs
    
    return erb(:main_page)
  end

  get '/sign_up' do
    erb(:sign_up_page)
  end

  post '/new_peep' do
    time = Time.now
    content = params[:content]
    peep = Peep.new(time, content, settings.user_id)
    peep_repo = PeepRepository.new
    peep_repo.add(peep)

    redirect '/'
  end
end
