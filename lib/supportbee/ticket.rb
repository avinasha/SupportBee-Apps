module SupportBee
  class Ticket < Resource
    class << self
      def list(auth={},params={})
        response = api_get(url,auth,params)
        ticket_array_from_multi_response(response, auth)
      end

      def search(auth={}, params={})
        return if params[:query].blank?
        response = api_get("#{url}/search",auth,params)
        ticket_array_from_multi_response(response, auth)
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
  
      private

      def ticket_array_from_multi_response(response, auth)
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
    end

    def archive
      archive_url = "#{url}/archive"
      api_post(archive_url)
      refresh
    end

    def unarchive
      archive_url = "#{url}/archive"
      api_delete(archive_url)
      refresh
    end

    def assign_to_user(user)
      user_id = user
      user_id = user.id if user.kind_of?(SupportBee::User)
      assignment_url = "#{url}/assignments"
      post_data = { :assignment => { :user_id => user_id }}
      api_post(assignment_url, :body => post_data)
      refresh
      SupportBee::Assignment.new(@params)
    end

    def assign_to_group(group)
      group_id = group
      group_id = group.id if group.kind_of?(SupportBee::Group)
      assignment_url = "#{url}/assignments"
      post_data = { :assignment => { :group_id => group_id }}
      api_post(assignment_url, :body => post_data)
      refresh
      SupportBee::Assignment.new(@params)
    end

    def unassign
      assignment_url = "#{url}/assignments"
      api_delete(assignment_url)
      refresh
    end

    def star
      star_url = "#{url}/star"
      api_post(star_url)
      refresh
    end

    def unstar
      unstar_url = "#{url}/star"
      api_delete(unstar_url)
      refresh
    end

    def spam
      spam_url = "#{url}/spam"
      api_post(spam_url)
      refresh
    end

    def unspam
      unspam_url = "#{url}/spam"
      api_delete(unspam_url)
      refresh
    end

    def trash
      trash_url = "#{url}/trash"
      api_post(trash_url)
      refresh
    end

    def untrash
      untrash_url = "#{url}/trash"
      api_delete(untrash_url)
      refresh
    end

    def replies(refresh=false)
      refresh = true unless @replies
      if refresh
        replies_url = "#{url}/replies"
        response = api_get(replies_url)
        @replies = to_replies_array(response).replies 
      end
      @replies
    end

    def refresh_reply(reply_id)
      replies_url = "#{url}/replies/#{reply_id}"
      response = api_get(replies_url)
      SupportBee::Reply.new(@params, response.body['reply'])
    end

    def reply(params={})
      replies_url = "#{url}/replies"
      post_body = { :reply => {} }
      post_body[:reply][:body] = params.delete(:text) if params[:text]
      post_body[:reply][:body_html] = params.delete(:html) if params[:html]
      post_body[:reply][:attachment_ids] = params.delete(:attachment_ids) if params[:attachment_ids]
      params[:body] = post_body
      response = api_post(url,@params,params)
      refresh
      SupportBee::Reply.new(@params, response.body['reply'])
    end

    def comments(comments=true)
      refresh = true unless @comments
      if refresh
        comments_url = "#{url}/comments"
        response = api_get(comments_url)
        @comments = to_comments_array(response).comments
      end
      @comments
    end

    def comment(params={})
      replies_url = "#{url}/comments"
      post_body = { :comment => {} }
      post_body[:comment][:body] = params.delete(:text) if params[:text]
      post_body[:comment][:body_html] = params.delete(:html) if params[:html]
      post_body[:comment][:attachment_ids] = params.delete(:attachment_ids) if params[:attachment_ids]
      params[:body] = post_body
      response = api_post(url,@params,params)
      refresh
      SupportBee::Comment.new(@params, response.body['comment'])
    end

    def labels_list
      unless @labels
        @labels = []
        labels.each do |label|
          @labels << SupportBee::Label.new(@params, label)
        end
      end
      @labels
    end

    def has_label?(label_name)
      not(labels_list.select{|label| label.name == label_name}.empty?)
    end

    def find_label(label_name)
      SupportBee::Label.find_by_name(@params,label_name)
    end

    def add_label(label_name)
      return if has_label?(label_name)
      return unless find_label(label_name)
      labels_url = "#{url}/labels/#{label_name}"
      api_post(labels_url)
      refresh
    end

    def remove_label(label_name)
      return unless has_label?(label_name)
      labels_url = "#{url}/labels/#{label_name}"
      api_delete(labels_url)
      refresh
    end

    private

    def to_replies_array(response)
      replies = []
      result = Hashie::Mash.new
      response.body.keys.each do |key|
        if key == 'replies'
          response.body[key].each do |reply|
            replies << Ticket::Reply.new(auth,reply)
          end
        else
          result[key] = response.body[key]
        end
      end
      result.replies = replies
      result
    end

    def to_comments_array(response)
      comments = []
      result = Hashie::Mash.new
      response.body.keys.each do |key|
        if key == 'comments'
          response.body[key].each do |comment|
            replies << Ticket::Comment.new(auth,comment)
          end
        else
          result[key] = response.body[key]
        end
      end
      result.comments = comments
      result
    end
  end
end
