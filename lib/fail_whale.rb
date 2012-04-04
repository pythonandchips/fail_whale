module FailWhale
  def self.configure(&block)
    FailWhale::Configuration.new(&block)
  end

  class Configuration
    def initialize(&block)
      @matchers = []
      self.instance_eval(&block)
    end

    def fail_on(url, &block)
      @matchers << Matcher.new(url, &block)
    end

    def matchers
      @matchers
    end
  end

  class Matcher
    attr_reader :url, :status, :response

    def initialize(url, &block)
      @url = url
      self.instance_eval(&block)
    end

    def with params
      @status = params[:status]
      @response = params[:return]
    end
  end

end
