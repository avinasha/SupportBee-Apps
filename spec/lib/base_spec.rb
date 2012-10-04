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

    it "should figure out the root from the class name" do
      Dummy::Base.root.to_s.should == "#{APPS_PATH}/dummy"
    end
  end
end
