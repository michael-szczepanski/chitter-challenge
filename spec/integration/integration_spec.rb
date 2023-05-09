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
      get('/')
      response = post('/new_peep', content: 'New post')
      expect(response.status).to eq 302
      response = get('/')
      expect(response.status).to eq 200
      expect(response.body).to include('New post')
      expect(response.body).to include('Anonymous')
    end
  end

  context 'GET /sign_up' do
    it 'correctly displays the sign up page' do
      response = get('/sign_up')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Sign up for a Chitter account</h1>')
      expect(response.body).to include('<form method="POST" action="/new_user">')
      expect(response.body).to include('name="username"')
      expect(response.body).to include('name="password"')
      expect(response.body).to include('name="email"')
      expect(response.body).to include('name="name"')
    end
  end

  context 'POST /new_user' do
    it 'adds a new user to the database' do
      response = post('/new_user', { name: 'Kevin', email: 'kevin@kevin.com', username: 'kevin', password: 'kevin' })
      expect(response.status).to eq 200
      expect(response.body).to include('Welcome to the Chitter gang, Kevin!')
    end
    it 'rejects a user with duplicate username' do
      response = post('/new_user', { name: 'Kevin', email: 'kevin@kevin.com', username: 'mike', password: 'kevin' })
      expect(response.status).to eq 400
    end
    it 'rejects a user with duplicate email' do
      response = post('/new_user', { name: 'Kevin', email: 'mike@mike.mike', username: 'mike', password: 'kevin' })
      expect(response.status).to eq 400
    end
  end

  context 'GET /log_in' do
    it 'displays a html document of the log in page' do
      response = get('/log_in')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Log in to your Chitter account</h1>')
      expect(response.body).to include('<form method="POST" action="/log_in">')
      expect(response.body).to include('name="username"')
      expect(response.body).to include('name="password"')
    end
  end

  context 'POST /log_in' do
    it 'retrieves a user object from the database' do
      post('/new_user', { name: 'Kevin', email: 'kevin@kevin.com', username: 'kevin', password: 'kevin1' })
      response = post('/log_in', { username: 'kevin', password: 'kevin1' })
      expect(response.status).to eq 302

      post('/new_peep', { content: 'my first post' })
      response = get('/')
      expect(response.body).to include 'Logged in as: Kevin'
      expect(response.body).to include 'my first post'
      expect(response.body).to include 'Kevin (kevin)'
    end
    it 'fails to log in a user if username/password not matched' do
      response = post('/log_in', { username: 'mike', password: 'incorrectpassword' })
      expect(response.status).to eq 400
    end
  end

  context 'POST /log_out' do
    it 'successfully logs out a user' do
      post('/new_user', { name: 'Kevin', email: 'kevin@kevin.com', username: 'kevin', password: 'kevin1' })
      post('/log_in', { username: 'kevin', password: 'kevin1' })
      response = get('/')
      expect(response.body).to include 'Logged in as: Kevin'
      response = post('/log_out')
      expect(response.status).to eq 302
      response = get('/')
      expect(response.body).not_to include 'Logged in as: Kevin'
    end
  end
end
