require "spec_helper"

describe "when failing an http call" do
  def make_request uri
    uri = URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
  end

  context "with one url registered" do
    context "and one failure configured" do
      it "should return the configured response" do
        FailWhale.configure do
          fail_on /pythonandchips.net/ do
            with :status => "404", :return => {"errors" => "That didny work"}
          end
        end
        response = make_request "http://blog.pythonandchips.net"
        response.code.should eql "404"
        response.body.should eql({"errors" => "That didny work"}.to_json)
      end
    end

    context "with multipule failures configured" do
      it "should choose at random which failure to use" do
        FailWhale.configure do
          fail_on /pythonandchips.net/ do
            with :status => "404", :return => {"errors" => "That didny work"}
            with :status => "500", :return => {"errors" => "think we might have buggered that up"}
          end
        end
        Array.any_instance.stub(:sample).and_return(FailWhale.configuration.matchers[0].failures[1])
        response = make_request "http://blog.pythonandchips.net"
        response.code.should eql "500"
        response.body.should eql({"errors" => "think we might have buggered that up"}.to_json)
      end
    end
  end

  context "with multipule url registered" do
    it "should select the configured response" do
      FailWhale.configure do
        fail_on /pythonandchips.net/ do
          with :status => "404", :return => {"errors" => "That didny work"}
        end
        fail_on /google.com/ do
          with :status => "500", :return => {"errors" => "whoops we seem to have a problem"}
        end
      end
      response = make_request "http://www.google.com"
      response.code.should eql "500"
      response.body.should eql({"errors" => "whoops we seem to have a problem"}.to_json)
    end
  end

  context "with no configuration" do
    it "should not fail if the url has not been registered" do
      FailWhale.configure do
      end
      response = make_request "http://blog.pythonandchips.net"
      response.code.should eql "200"
    end
  end
end


