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
      params = {}
      spec_components = route_spec.split('/')
      req_components = request.path.split('/')

      return nil unless spec_components.length == req_components.length
      
      spec_components.zip(req_components).each do |spec_component, req_component|
        is_variable = spec_component.start_with?(':')
        
        if is_variable
          key = spec_component.sub(/\A:/, '')
          params[key] = req_component
        else
          return nil unless spec_component == req_component
        end
      end
      block.call(params)
    end
  end
end