module FailWhale
  class Configuration
    def initialize(&block)
      @matchers = []
      self.instance_eval(&block)
    end

    def fail_on(url, *args, &block)
      @matchers << Matcher.new(url, &block)
    end

    def find_match_for(url)
      @matchers.detect{|matcher| matcher.url =~ url}
    end

    def matchers
      @matchers
    end
  end
end
