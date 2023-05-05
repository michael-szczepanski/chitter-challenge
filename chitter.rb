require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/database_connection'

DatabaseConnection.connect

class Chitter < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    # also_reload lib/peep_repository
    # also_reload lib/account_repository
  end

  get '/' do
    return erb(:welcome_page)
  end

end
