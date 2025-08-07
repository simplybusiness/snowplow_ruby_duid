# frozen_string_literal: true

module SnowplowRubyDuid
  # This is the same as SnowplowRubyDuid::Helper, except it handles the HTTP
  # objects that the Grape API (https://github.com/ruby-grape/grape) exposes
  # (`response`, `request`, `request.cookies`) in an appropriate manner.

  COOKIE_PREFIX_PATTERN = /^#{KEY_PREFIX}/o

  module GrapeHelper
    def snowplow_domain_userid
      @snowplow_domain_userid ||= find_or_create_snowplow_domain_userid
    end

    private

    def find_or_create_snowplow_domain_userid
      find_snowplow_domain_userid || create_snowplow_domain_userid
    end

    def create_snowplow_domain_userid
      request_created_at = Time.now
      domain_userid      = DomainUserid.new.to_s
      options = {
        secure: Configuration.secure,
        same_site: Configuration.same_site
      }
      snowplow_cookie = Cookie.new request.host, domain_userid, request_created_at, options

      # Grape has no "response" object but uses the `header` DSL or the `cookies` local var
      # header 'Set-Cookie', "#{snowplow_cookie.key}=#{snowplow_cookie.value}; Path=/; HttpOnly"
      cookies[snowplow_cookie.key] = snowplow_cookie.value
      domain_userid
    end

    # See: https://docs.snowplow.io/docs/sources/trackers/ruby-tracker/adding-data-events/#cookie-based-user-properties
    def find_snowplow_domain_userid
      snowplow_cookie = find_snowplow_cookie # [key, value] format
      # The cookie value format: domainUserId.createTs.visitCount.nowTs.lastVisitTs
      snowplow_cookie.last.split('.').first unless snowplow_cookie.nil?
    end

    # @uses request[Grape::Cookies]  Not a real parameter, but comes from the code this is mixed into.
    # @return [Hash{string => string}, nil] Snowplow cookie key/value or nil if not found.
    def find_snowplow_cookie
      snowplow_cookie = nil
      request.cookies.each do |(key, value)|
        if COOKIE_PREFIX_PATTERN.match?(key)
          snowplow_cookie = [key, value]
          break
        end
      end
      snowplow_cookie
    end
  end
end
