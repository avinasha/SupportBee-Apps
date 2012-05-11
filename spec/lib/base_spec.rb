require 'spec_helper'

describe SupportBeeApp::Base do
	describe "ClassMethods" do
		it "should respond to env" do
			SupportBeeApp::Base.env.should == 'test'
		end

		context "schema" do
			describe ".add_to_schema" do
				it "should add to schema" do
					SupportBeeApp::Base.add_to_schema(:string, [:username, :token])
					SupportBeeApp::Base.schema.should == [[:string, :username],[:string, :token]]
				end
			end
		end
		
	end
end