module SupportBee
   class InvalidAuthToken < ::StandardError; end
   class InvalidSubDomain < ::StandardError; end

  class Base
    include HttpHelper

    class << self
      def self.class_name
        self.name.split('::')[-1]
      end

      def create_method(name, &block)
        self.send(:define_method, name, &block)
      end
    end

    def initialize(data={}, payload={})
      raise NotImplementedError.new('SupportBee::Base is an abstract class.  You should perform actions on its subclasses (Ticket, Reply, etc.)') if self.class == SupportBee::Base
      @params = data
      raise InvalidAuthToken if @params[:auth_token].blank?
      raise InvalidSubDomain if @params[:subdomain].blank?
      load_attributes(payload)
    end

    def api_endpoint
      @api_endpoint ||= "#{APP_CONFIG['core_app_protocol']}://#{@params[:subdomain]}.#{APP_CONFIG['core_app_base_domain']}:#{APP_CONFIG['core_app_port']}"
    end

    def default_params
      { :auth_token => @params[:auth_token] }
    end

    def default_headers
      {'Accept' => 'application/json'}
    end

    def api_get(resource_url, params={})
      params = default_params.merge(params)
      url = "#{api_endpoint}#{resource_url}"
      http_get(url, params, default_headers)
    end

    def api_post(resource_url, body=nil)
      url = "#{api_endpoint}#{resource_url}"
      http_post(url, body, default_headers) do |req|
        req.params = default_params
      end
    end

    def api_put(resource_url, body=nil)
      url = "#{api_endpoint}#{resource_url}"
      http_method(:put, url, body, default_headers) do |req|
        req.params = default_params
      end
    end

    def api_delete(resource_url)
      url = "#{api_endpoint}#{resource_url}"
      http_method(:delete, url, nil, default_headers) do |req|
        req.params = default_params
      end
    end

    private 

    def load_attributes(hash)
      @attributes = Hashie::Mash.new(hash)
      hash.keys.each do |key|
        self.class.create_method(key) { @attributes.send(key) }
        self.class.create_method("#{key}=") { |value| @attributes.send("#{key}=", value) }
      end
    end
  end
end

require_relative 'supportbee/resource'
