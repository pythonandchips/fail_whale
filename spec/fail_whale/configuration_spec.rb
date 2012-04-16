require "spec_helper"

describe FailWhale::Configuration do
  Given(:configuration) do
    configuration = FailWhale::Configuration.new do
      fail_on /pythonandchips.net/ do
        with :status => "400", :return => {"error" => "that doesny work"}
        with :status => "500", :return => {"error" => "do think that worked"}
      end
    end
    configuration
  end

  describe "reading configuration" do

    Then { configuration.matchers.length.should eql 1 }

    describe "matcher content" do
      Given(:matcher){configuration.matchers.first}
      Then { matcher.url.should == /pythonandchips.net/ }
      Then { matcher.failures.length.should eql 2}

      describe "the failures" do
        Given(:failures){ matcher.failures }
        Then { failures.first.status.should == "400" }
        Then { failures.first.response.should == {"error" => "that doesny work"} }
        Then { failures[1].status.should == "500" }
        Then { failures[1].response.should == {"error" => "do think that worked"} }
      end
    end
  end

  describe "find a matching failure" do
    When(:matcher) { configuration.find_match_for("http:://pythonandchips.net") }
    Then { matcher.url.should == /pythonandchips.net/ }
  end


end
