module SupportBee
  class Resource < Base
    class << self
      def url
        if self == Resource
          raise NotImplementedError.new('APIResource is an abstract class.  You should perform actions on its subclasses (Ticket, Reply, etc.)')
        end
        "/#{CGI.escape(class_name.downcase)}s"
      end

      def list(params={})
      end
    end

    def url
      unless id = self['id']
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
      "#{self.class.url}/#{CGI.escape(id)}"
    end

    def refresh
    end

    def create(body=nil)
    end

    def update(body=nil)
    end

    def delete
    end
  end
end
