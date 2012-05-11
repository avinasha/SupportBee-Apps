class SupportBeeApp::Campfire < SupportBeeApp::Base
	string :subdomain, :token, :room_ids
	set_title 'Campfire'
	set_stub 'campfire'

	class << self
		attr_accessor :campfire_class
	end

	self.campfire_class = Tinder::Campfire

	def receive_ticket_created
    speech = "[#{payload['company']['name']}:New Ticket] #{payload['ticket']['subject']}\n https://#{payload['company']['subdomain']}.supportbee.com/tickets/#{payload['ticket']['id']}"
		speak(speech)
	end

	attr_writer :campfire
	attr_writer :room_ids
  def campfire
    @campfire ||= self.class.campfire_class.new(campfire_domain, :ssl => true, :token => data['token'])
  end

  def room_ids
  	@room_ids ||= data['room_ids'].split(',').collect {|room_str| room_str.to_i }
  end

  def campfire_domain
    data['subdomain'].to_s.sub /\.campfirenow\.com$/i, ''
  end

  def speak(message)
     room_ids.each do |room_id|
       room = campfire.find_room_by_id(room_id)
       room.speak(message)
     end
  end
    
  def paste(message)
    room_ids.each do |room_id|
    	room = campfire.find_room_by_id(room_id)
      room.paste(message)
    end
   end
end