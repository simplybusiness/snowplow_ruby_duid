# frozen_string_literal: true

module SnowplowRubyDuid
  # Responsible for generating a cookie that emulates the Snowplow cookie as closely as possible
  # Leverages the method used by ActionDispatch::Cookies::CookieJar to determine the top-level domain
  class Cookie
    # See: https://github.com/snowplow/snowplow-javascript-tracker/blob/d3d10067127eb5c95d0054c8ae60f3bdccba619d/src/js/tracker.js#L142
    COOKIE_PATH            = '/'
    # See: https://github.com/snowplow/snowplow-javascript-tracker/blob/d3d10067127eb5c95d0054c8ae60f3bdccba619d/src/js/tracker.js#L156
    COOKIE_DURATION_MONTHS = 24
    # See: https://github.com/rails/rails/blob/b1124a2ac88778c0feb0157ac09367cbd204bf01/actionpack/lib/action_dispatch/middleware/cookies.rb#L214
    DOMAIN_REGEXP          = /[^.]*\.([^.]*|..\...|...\...)$/.freeze

    def initialize(host, domain_userid, request_created_at, request_scheme)
      @host               = host
      @domain_userid      = domain_userid
      @request_created_at = request_created_at
      @request_scheme     = request_scheme
    end

    # See: https://github.com/snowplow/snowplow-javascript-tracker/blob/d3d10067127eb5c95d0054c8ae60f3bdccba619d/src/js/tracker.js#L358-L360
    # See: https://github.com/snowplow/snowplow-javascript-tracker/blob/d3d10067127eb5c95d0054c8ae60f3bdccba619d/src/js/tracker.js#L372-L374
    def key
      domain = top_level_domain || @host
      KEY_PREFIX + '.' + Digest::SHA1.hexdigest(domain + COOKIE_PATH)[0..3]
    end

    def value
      cookie_domain = ".#{top_level_domain}" unless top_level_domain.nil?
      {
        value: cookie_value,
        expires: cookie_expiration,
        domain: cookie_domain,
        path: COOKIE_PATH,
        same_site: :none,
        secure: @request_scheme == 'https',
      }
    end

    private

    # See: https://github.com/rails/rails/blob/b1124a2ac88778c0feb0157ac09367cbd204bf01/actionpack/lib/action_dispatch/middleware/cookies.rb#L286-L294
    def top_level_domain
      $& if (@host !~ /^[\d.]+$/) && (@host =~ DOMAIN_REGEXP)
    end

    # See: https://github.com/snowplow/snowplow-javascript-tracker/blob/d3d10067127eb5c95d0054c8ae60f3bdccba619d/src/js/tracker.js#L476-L487
    def cookie_value
      visit_count = '0'
      last_visit_ts = ''
      create_ts = now_ts = @request_created_at.to_i.to_s
      [@domain_userid, create_ts, visit_count, now_ts, last_visit_ts].join '.'
    end

    def cookie_expiration
      expiration_date = @request_created_at.to_datetime >> COOKIE_DURATION_MONTHS
      expiration_date.to_time
    end
  end
end
