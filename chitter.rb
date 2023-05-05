require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/database_connection'
require_relative './lib/peep'
require_relative './lib/peep_repository'

DatabaseConnection.connect

class Chitter < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    # also_reload lib/peep_repository
    # also_reload lib/account_repository
  end

  get '/' do
    return erb(:main_page)
  end

  post '/new_peep' do
    @time = Time.now
    @content = params[:content]
    @account_id = params[:account_id].to_i
    peep = Peep.new(@time, @content, @account_id)

    peep_repo = PeepRepository.new
    peep_repo.add(peep)

    redirect '/'
  end

end
