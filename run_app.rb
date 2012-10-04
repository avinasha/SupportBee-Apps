require 'sinatra/base'
require 'sinatra-initializers'

class RunApp < Sinatra::Base
  
  register Sinatra::Initializers

  def self.setup(app_class)
    get "/#{app_class.slug}" do
      app_class.name
    end

    post "/#{app_class.slug}/:event" do
      event, data, payload = parse_request
      if app = app_class.receive(event, data, payload)
        "OK"
      end
    end
  end

  SupportBeeApp::Base.apps.each do |app|
    app.setup_for(self)
  end

  get "/" do
    "OK"
  end

  def parse_request
    parse_json_request
  end

  def parse_json_request
    req = JSON.parse(request.body.read)
    [params[:event], req['data'], req['payload']]
  end

  run! if app_file == $0
end
