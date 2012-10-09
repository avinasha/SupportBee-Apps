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

    def url
      unless id = self['id']
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
      "#{self.class.url}/#{CGI.escape(id)}"
    end

    def refresh
      response = api_get(url)
      load_attributes(response.body[key])
    end

    def delete
      api_delete(url)
    end
  end
end
