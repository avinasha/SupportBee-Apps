require 'spec_helper'

describe SupportBeeApp::Base do
  describe "ClassMethods" do
		describe "Env" do
      it "should respond to env" do
			  SupportBeeApp::Base.env.should == 'test'
		  end

      it "should have env helper methods" do
        SupportBeeApp::Base.should be_test
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
      context "Event" do; end
      context "Action" do; end
    end
  end
end
