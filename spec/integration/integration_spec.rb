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
      expect(response.body).to include('<h2>See what people are talking about:</h2>')
      expect(response.body).to include('Mikes peep')
      expect(response.body).to include('Rubys peep')
      expect(response.body).to include('2023-05-05')
    end
  end

  context 'POST /new_peep' do
    it 'adds a post to the database' do
      response = post('/new_peep', { content: 'New post' })
      expect(response.status).to eq 302
      response = get('/')
      expect(response.status).to eq 200
      expect(response.body).to include('New post')
      expect(response.body).to include('Anonymous')
    end
  end

  context 'GET /sign-up' do
    
end
