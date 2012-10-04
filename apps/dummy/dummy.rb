module Dummy
  module EventHandler
    def ticket_created; end
    def ticket_updated; end

    def reply_created; end
    def reply_updated; end
  end
end

module Dummy
  module ActionHandler
    def action_button
     # Handle Action here
    end
  end
end

module Dummy
  class Base < SupportBeeApp::Base
    string :name, :required => true
    password :key, :required => true, :label => 'Token'
    boolean :active, :default => true
  end
end
