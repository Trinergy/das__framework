require_relative 'framework'
require_relative 'database'
require_relative 'queries'

DB = Database.connect('postgres://localhost/kenny_test', QUERIES)

APP = App.new do
  get '/' do
    'this is the root!'
  end

  get '/users/:username' do |params|
    "this is the #{params.fetch('username')} page!"
  end

  get '/submissions' do
    DB.all_submissions
  end

  get '/submissions/:name' do |params|
    name = params.fetch('name')
    DB.find_submission_by_name(name).fetch(0)
  end
end