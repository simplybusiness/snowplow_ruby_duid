# frozen_string_literal: true

require 'digest/sha1'
require 'snowplow_ruby_duid/cookie'
require 'snowplow_ruby_duid/domain_userid'
require 'snowplow_ruby_duid/helper'

module SnowplowRubyDuid
  KEY_PREFIX = '_sp_id'.freeze
end

ActionController::Base.send :include, SnowplowRubyDuid::Helper if defined?(ActionController)
