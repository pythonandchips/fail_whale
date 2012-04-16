require 'rspec'
require 'rspec/given'
require 'net/http'
require 'fail_whale'
require 'in_every'
require "awesome_print"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end
