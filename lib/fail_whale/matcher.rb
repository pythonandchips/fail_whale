module FailWhale
  class Matcher
    attr_reader :url, :failures

    def initialize(url, &block)
      @url = url
      @failures = []
      self.instance_eval(&block)
    end

    def with params
      @failures << Failures.new(params[:status], params[:return])
    end

    def choose_failure
      @failures.sample
    end
  end

  class Failures
    attr_reader :status, :response
    def initialize(status, response)
      @status = status
      @response = response
    end
  end
end
