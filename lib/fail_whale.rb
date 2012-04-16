require "net/http"
require "json"
require "fail_whale/configuration"
require "fail_whale/matcher"

module FailWhale
  def self.configure(&block)
    @configuration = FailWhale::Configuration.new(&block)

    Net::HTTP.class_eval do
      org_request = self.instance_method(:request)

      define_method(:request) do |req, body=nil, &block|
        url = address + req.path
        if matcher = FailWhale.configuration.find_match_for(url)
          failure = matcher.choose_failure
          response = Net::HTTPNotFound.new('1.1', failure.status, nil)
          response.instance_variable_set(:@read, true)
          response.body = failure.response.to_json
          response
        else
          org_request.bind(self).call(req, body, &block)
        end
      end
    end
  end

  def self.configuration
    @configuration
  end
end
