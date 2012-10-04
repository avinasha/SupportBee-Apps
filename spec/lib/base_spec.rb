require 'spec_helper'

describe SupportBeeApp::Base do
  describe "ClassMethods" do
		describe "Variables" do
      it "should respond to env" do
			  Dummy::Base.env.should == 'test'
		  end

      it "should have env helper methods" do
        Dummy::Base.should be_test
      end

      it "should set name" do
        Dummy::Base.name.should == 'Dummy'
      end 

      it "should set slug" do
        Dummy::Base.slug.should == 'dummy'
      end
    end

    describe "Paths" do
      it "should figure out the root from the class name" do
        Dummy::Base.root.to_s.should == "#{APPS_PATH}/dummy"
      end

      it "should set the assets path" do
        Dummy::Base.assets_path.to_s.should == "#{APPS_PATH}/dummy/assets"
      end

      it "should set the views path" do
        Dummy::Base.views_path.to_s.should == "#{APPS_PATH}/dummy/assets/views"
      end
    end

    describe "Configuration" do
      it "should load configurations from config.yml" do
        Dummy::Base.configuration['name'].should == 'Dummy'
        Dummy::Base.configuration['slug'].should == 'dummy'
      end
    end

    describe "Schema" do
      it "should have the right schema" do
        Dummy::Base.schema.should == {
          'name' => {'type' => 'string', 'label' => 'Name', 'required' => true},
          'key' => {'type' => 'password', 'label' => 'Token', 'required' => true},
          'active' => {'type' => 'boolean', 'label' => 'Active', 'required' => false,'default' => true }
        }
      end
    end
  end

  describe "Instance" do
    it "should have all event handler methods" do
      Dummy::Base.new.should respond_to('ticket_created')
    end

    it "should have all action handler methods" do
      Dummy::Base.new.should respond_to('action_button')
    end

    describe "Receive" do
      context "Event" do
        it "should trigger an event" do
          dummy = Dummy::Base.new
          flexmock(dummy).should_receive(:ticket_created).once
          dummy.trigger_event('ticket.created')
        end

        it "should trigger all_events for any event" do
          dummy = Dummy::Base.new
          flexmock(dummy).should_receive(:all_events).once
          dummy.trigger_event('ticket.created')
        end

        it "should silently fail if the app does not handle the event" do
          dummy = Dummy::Base.new
          lambda{
            dummy.trigger_event('blah')
          }.should_not raise_error
        end
      end
      context "Action" do 
        it "should trigger a action" do
          dummy = Dummy::Base.new
          flexmock(dummy).should_receive(:action_button).once
          dummy.trigger_action('action_button')
        end

        it "should trigger all_actions for any action" do
          dummy = Dummy::Base.new
          flexmock(dummy).should_receive(:all_actions).once
          dummy.trigger_action('action_button')
        end

        it "should silently fail if the app does not handle an action" do
          dummy = Dummy::Base.new
          lambda{
            dummy.trigger_action('blah')
          }.should_not raise_error
        end
      end
    end
  end
end
