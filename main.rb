require_relative 'framework'

APP = App.new do
  get '/' do
    'this is the root!'
  end

  get '/users/:username' do |params|
    "this is the #{params.fetch('username')} page!"
  end
end