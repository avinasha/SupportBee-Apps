module SupportBee
  class User < Resource
    class << self
      def list(auth={}, params={})
        response = api_get(url,auth,params)
        user_array_from_multi_response(response, auth)
      end

      private

      def user_array_from_multi_response(response, auth)
        users = []
        result = Hashie::Mash.new
        response.body.keys.each do |key|
          if key == 'users'
            response.body[key].each do |user|
              users << self.new(auth,user)
            end
          else
            result[key] = response.body[key]
          end
        end
        result.users = users
        result
      end
    end
  end
end
