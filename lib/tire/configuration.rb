module Tire

  class Configuration

    # Accept an array of servers instead of a single string
    def self.url(value=nil)
      if value.nil?
        @url = @url || ENV['ELASTICSEARCH_URL'] || "http://localhost:9200"
      elsif value.is_a?(String)
        @url = value.to_s.gsub(%r|/*$|, '')
      elsif value.is_a?(Array)
        @url = value.sample.to_s.gsub(%r|/*$|, '')
      else
        raise "Unknown URL format"
      end
    end

    def self.client(klass=nil)
      @client = klass || @client || HTTP::Client::RestClient
    end

    def self.wrapper(klass=nil)
      @wrapper = klass || @wrapper || Results::Item
    end

    def self.logger(device=nil, options={})
      return @logger = Logger.new(device, options) if device
      @logger || nil
    end

    def self.pretty(value=nil, options={})
      if value === false
        return @pretty = false
      else
        @pretty.nil? ? true : @pretty
      end
    end

    def self.reset(*properties)
      reset_variables = properties.empty? ? instance_variables : instance_variables.map { |p| p.to_s} & \
                                                                 properties.map         { |p| "@#{p}" }
      reset_variables.each { |v| instance_variable_set(v.to_sym, nil) }
    end

  end

end
