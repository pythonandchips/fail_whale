require "spec_helper"

describe "when failing an http call" do
  it "should return the configured response" do
    FailWhale.configure do
      fail_on /pythonandchips.net/ do
        with :status => "404", :return => {"errors" => "That didny work"}
      end
    end

    uri = URI.parse("http://pythonandchips.net")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    response.code.should eql "404"
    response.body.should eql({"errors" => "That didny work"}.to_json)
  end
end


