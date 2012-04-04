require "spec_helper"

describe FailWhale::Configuration do

  describe "reading configuration" do
    Given(:configuration) do
      configuration = FailWhale::Configuration.new do
        fail_on /pythonandchips.net/ do
          with :status => "400", :return => {"error" => "that doesny work"}
        end
      end
      configuration
    end

    Then { configuration.matchers.length.should eql 1 }

    describe "matcher content" do
      Given(:matcher){configuration.matchers.first}
      Then { matcher.url.should == /pythonandchips.net/ }
      Then { matcher.status.should == "400" }
      Then { matcher.response.should == {"error" => "that doesny work"} }
    end
  end


end
