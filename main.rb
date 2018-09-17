class App
  def initialize(&block)
    @routes = RoutesTable.new(&block)
  end

  def call(env)
    request = Rack::Request.new(env)
    @routes.each do |route|
      content = route.match(request)
      return [200, {}, [content]] if content
    end
    [404, {}, ['Page does not exist']]
  end

  class RoutesTable
    def initialize(&block)
      @routes = []
      instance_eval(&block)
    end

    def each(&block)
      @routes.each(&block)
    end

    def get(route_spec, &block)
      @routes << Route.new(route_spec, block)
    end
  end

  class Route < Struct.new(:route_spec, :block)
    def match(request)
      block.call() if request.path == route_spec
      nil
    end
  end
end

APP = App.new do
  get '/' do
    'this is the root!'
  end

  get '/users/:username' do
    'this is the users page!'
  end
end