module Dummy
  module Event 
    def ticket_created; end
    def ticket_updated; end

    def reply_created; end
    def reply_updated; end
  end
end

module Dummy
  module Action
    def action_button
     # Handle Action here
    end
  end
end

module Dummy
  class Base < SupportBeeApp::Base
    
  end
end
