# frozen_string_literal: true

module SnowplowRubyDuid
  # This is the configuration object that is used for two additional cookie settings
  # that can't be deferred from the request/response objects
  module Configuration
    @allowed = %i[none lax strict]

    @same_site = :lax
    @secure = false

    def self.same_site=(value)
      raise "Not allowed value #{value}, use one of these: #{@allowed}" unless @allowed.include?(value)

      @same_site = value
    end

    def self.secure=(value)
      @secure = value
    end

    def self.same_site
      @same_site
    end

    def self.secure
      @secure
    end
  end
end
