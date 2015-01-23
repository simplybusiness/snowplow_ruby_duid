module SnowplowRubyDuid
  # Generates a pseudo-unique ID to fingerprint the user
  # Attempts to emulate this Snowplow Jacascript: https://github.com/snowplow/snowplow-javascript-tracker/blob/d3d10067127eb5c95d0054c8ae60f3bdccba619d/src/js/tracker.js#L468-L472
  class DomainUserid
    FINGERPRINT_FIELDS = %w{ HTTP_ACCEPT HTTP_USER_AGENT HTTP_ACCEPT_ENCODING HTTP_ACCEPT_LANGUAGE }

    def initialize request_env, request_created_at
      @request_env        = request_env
      @request_created_at = request_created_at
    end

    def to_s
      domain_user_id
    end

    private

    def domain_user_id
      (Digest::SHA1.hexdigest request_fingerprint)[0..15]
    end

    def request_fingerprint
      FINGERPRINT_FIELDS.inject('') { |fingerprint, field|  fingerprint + (@request_env[field] || '') } + @request_created_at.to_f.to_s
    end
  end
end
