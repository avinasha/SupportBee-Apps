module SupportBee
  class Label < Resource
    class << self
      def list(auth={}, params={})
        response = api_get(url,auth,params)
        to_labels_array(response,auth)
      end

      def find_by_name(auth={}, name,params={})
        list.select{|label| label.name == name}.first
      end

      private

      def to_labels_array(response, auth)
        labels = []
        result = Hashie::Mash.new
        response.body.keys.each do |key|
          if key == 'labels'
            response.body[key].each do |label|
              labels << self.new(auth,label)
            end
          else
            result[key] = response.body[key]
          end
        end
        result.labels = labels
        result
      end
    end

    def refresh
      raise NotImplementedError.new('A label cannot be refreshed')
    end
  end
end
