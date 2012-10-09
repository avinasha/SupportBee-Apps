module SupportBee
  class Ticket < Resource
    class << self
      def list(auth={},params={})
        response = api_get(url,auth,params)
        tickets = []
        result = Hashie::Mash.new
        response.body.keys.each do |key|
          if key == 'tickets'
            response.body[key].each do |ticket|
              tickets << self.new(auth,ticket)
            end
          else
            result[key] = response.body[key]
          end
        end
        result.tickets = tickets
        result
      end

      def create(auth={},params={})
        ticket_attributes = {:content_attributes => {}}
        ticket_attributes[:requester_name] = params.delete(:requester_name)
        ticket_attributes[:requester_email] = params.delete(:requester_email)
        ticket_attributes[:subject] = params.delete(:subject)
        ticket_attributes[:content_attributes][:body] = params.delete(:text) if params[:text]
        ticket_attributes[:content_attributes][:body_html] = params.delete(:html) if params[:html]
       
        post_body = {:ticket => ticket_attributes}
        params[:body] = post_body
        response = api_post(url,auth,params)
        self.new(auth,response.body['ticket'])
      end
    end

    def delete
      raise NotImplementedError.new('A Ticket cannot be deleted')
    end
  end
end
