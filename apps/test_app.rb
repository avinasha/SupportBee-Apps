class TestApp < SupportBeeApp::Base
	string :token
	set_title 'Test App'
	set_stub 'test_app'

	def receive_ticket_created
		puts 'in ticket created'
	end
end