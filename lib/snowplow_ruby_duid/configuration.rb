module SnowplowRubyDuid
  module Configuration
    @@allowed = [:none, :lax, :strict]

    @@same_site = :none
    @@secure = true

    def self.same_site=(value)
      unless @@allowed.include?(value)
        raise "Not allowed value #{value}, use one of these: #{@@allowed}"
      end
      @@same_site = value
    end

    def self.secure=(value)
      @@secure = value
    end

    def self.same_site
      @@same_site
    end

    def self.secure
      @@secure
    end
  end
end
