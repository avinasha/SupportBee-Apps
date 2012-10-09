module SupportBee
  class Resource < Base
    class << self
      def key
        @key || class_name.downcase
      end

      def key=(value)
        @key = value
      end

      def url
        if self == Resource
          raise NotImplementedError.new('APIResource is an abstract class.  You should perform actions on its subclasses (Ticket, Reply, etc.)')
        end
        "/#{CGI.escape(key)}s"
      end
    end

    attr_reader :current_company

    def initialize(data={}, payload={})
      super(data, payload)
      @current_company = SupportBee::Company.new(@params, @params[:current_company]) if @params[:current_company]
    end

    def url
      unless id
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
      "#{self.class.url}/#{id}"
    end

    def refresh
      response = api_get(url)
      load_attributes(response.body[self.class.key])
      self
    end
  end
end
