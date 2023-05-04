require_relative '../../chitter'
require 'spec_helper'
require 'rack/test'

RSpec.describe Chitter do
  include Rack::Test::Methods

  let(:app) { Chitter.new }

  before(:each) do
    reset_database
  end

  context 'GET /' do
    it 'displays a welcome page' do
      response = get('/')

      expect(response.body).to include('<h1>Welcome to Chitter</h1>')
    end
  end

end