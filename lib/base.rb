module SupportBeeApp
	class Base
		
    include SupportBeeApp::HttpHelpers

    class << self
			def env
        @env ||= PLATFORM_ENV
      end

      def slug
        configuration['slug']
      end

      def name
        configuration['name']
      end

      def current_sha
        @current_sha ||=
          `cd #{PLATFORM_ROOT}; git rev-parse HEAD 2>/dev/null || echo unknown`.
          chomp.freeze
      end

      attr_writer :current_sha

      %w(development test production staging).each do |m|
      	define_method "#{m}?" do
        	env == m
      	end
    	end

    	def apps
				@apps ||= []
			end

      def root
        Pathname.new(APPS_PATH).join(app_module.to_s.underscore)
      end

      def app_module
        self.to_s.deconstantize.constantize
      end

      def assets_path
        root.join('assets')
      end

      def views_path
        assets_path.join('views')
      end
    
      def configuration
        @configuration ||= YAML.load_file(root.join('config.yml').to_s)
      end

      def schema
				@schema ||= {}
			end

      def info
        {
          'name' => configuration['name'],
          'slug' => configuration['slug'],
          'configuration' => configuration,
          'schema' => schema
        }
      end

			def add_to_schema(type,name,options={})
        type = type.to_s
        name = name.to_s
        required = options.delete(:required) ? true : false
        default = options.delete(:default)
        label = options.delete(:label) || name.humanize
        schema[name] = { 'type' => type, 'required' => required, 'label' => label }
        schema[name]['default'] = default if default
        schema
    	end

    	def string(name, options={})
      	add_to_schema :string, name, options
    	end

    	def password(name, options={})
      	add_to_schema :password, name, options
    	end

    	def boolean(name, options={})
      	add_to_schema :boolean, name, options
    	end

      def event_methods
        event_handler ? event_handler.instance_methods : []
      end

      def action_methods
        action_handler ? action_handler.instance_methods : []
      end

    	def trigger_event(event, data, payload = nil)
    		app = new(data,payload)
        app.receive_event(event)
    	end

      def trigger_action(action, data, payload = nil)
    		app = new(data,payload)
        app.receive_action(action)
    	end

      def event_handler
        app_module.const_defined?("EventHandler") ? app_module.const_get("EventHandler") : nil
      end

      def action_handler
        app_module.const_defined?("ActionHandler") ? app_module.const_get("ActionHandler") : nil
      end

    	def inherited(app)
        app.send(:include, app.event_handler) if app.event_handler
        app.send(:include, app.action_handler) if app.action_handler
      	SupportBeeApp::Base.apps << app 
      	super
    	end

    	def setup_for(sinatra_app)
    		sinatra_app.setup(self)
    	end
		end

		self.env ||= PLATFORM_ENV

    attr_reader :data
		attr_reader :payload
    attr_reader :supportbee

    attr_writer :ca_file

		def initialize(data = {}, payload = nil)
    	@data = data || {}
    	@payload = payload || {}
      @supportbee = SupportBee.new(data[:auth_token])
  	end

    def trigger_event(event)
      @event = event
      method = to_method(event)
      self.send method if self.respond_to?(method)
      all_events if self.respond_to?(:all_events)
    end

    def trigger_action(action)
      @action = action
      method = to_method(action)
      self.send method if self.respond_to?(method)
      all_actions if self.respond_to?(:all_actions)
    end 

    private
    
    def to_method(string)
      string.gsub('.','_').underscore
    end
	end
end
