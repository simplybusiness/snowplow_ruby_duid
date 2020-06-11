# frozen_string_literal: true

require 'securerandom'

module SnowplowRubyDuid
  # Generates a pseudo-unique ID to fingerprint the user
  # It follows Snowplow Javascript: https://github.com/snowplow/snowplow-javascript-tracker/blob/2.14.0/src/js/tracker.js#L670-L672
  class DomainUserid
    def initialize
      @domain_user_id = domain_user_id
    end

    def to_s
      @domain_user_id
    end

    private

    def domain_user_id
      SecureRandom.uuid
    end
  end
end
