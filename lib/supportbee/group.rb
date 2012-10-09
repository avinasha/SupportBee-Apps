module SupportBee
  class Group < Resource
    class << self
      def list(auth={}, params={})
        response = api_get(url,auth,params)
        group_array_from_multi_response(response, auth)
      end

      def with_users(auth={},params={})
        params[:with_users] = true
        list(auth, params)
      end

      def mine(auth={}, params={})
        params[:me] = true
        list(auth, params)
      end

      private

      def group_array_from_multi_response(response, auth)
        groups = []
        result = Hashie::Mash.new
        response.body.keys.each do |key|
          if key == 'groups'
            response.body[key].each do |group|
              groups << self.new(auth,group)
            end
          else
            result[key] = response.body[key]
          end
        end
        result.groups = groups
        result
      end
    end
  end
end

