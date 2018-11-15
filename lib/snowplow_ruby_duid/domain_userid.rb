require 'securerandom'

module SnowplowRubyDuid
  # Generates a pseudo-unique ID to fingerprint the user
  # Deviates from this Snowplow Javascript: https://github.com/snowplow/snowplow-javascript-tracker/blob/d3d10067127eb5c95d0054c8ae60f3bdccba619d/src/js/tracker.js#L468-L472
  #   in order to provide a more unique identifier
  class DomainUserid
    LENGTH_OF_DUID_IN_BYTES = 8

    def initialize
      @domain_user_id = domain_user_id
    end

    def to_s
      @domain_user_id
    end

    private

    def domain_user_id
      SecureRandom.hex LENGTH_OF_DUID_IN_BYTES
    end
  end
end
