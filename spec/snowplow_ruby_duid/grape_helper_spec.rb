# frozen_string_literal: true

require 'snowplow_ruby_duid/grape_helper'
require 'timecop'

require 'rspec'
RSpec.describe 'SnowplowRubyDuid::GrapeHelper' do
  context 'the cookie has been set before' do
    let(:subject) { GrapeHelperSpecTestApp.new }
    let(:snowplow_cookie_id) { '_sp_id.79723' }
    let(:snowplow_cookie_value) { 'domainUserId.createTs.visitCount.nowTs.lastVisitTs' }

    before do
      subject.request.cookies[snowplow_cookie_id] = snowplow_cookie_value
    end

    it 'finds the cookie and returns the domain id' do
      expect(subject.snowplow_domain_userid).to eq('domainUserId')
    end
  end

  context 'the cookie has not been set before' do
    let(:subject) { GrapeHelperSpecTestApp.new }

    before do
      Timecop.freeze(Time.local(2025, 2, 1, 10, 0, 0))
    end

    after do
      Timecop.return
    end

    it "creates a new domain id cookie if one doesn't exist" do
      # Start with empty cookies.
      expect(subject.request.cookies).to eq({})

      got_userid = subject.snowplow_domain_userid
      # These are random/uuids, but have this format: "60bde8c9-8047-410c-97a8-d73af82f90fe"
      expect(got_userid).to match(/^([0-9a-fA-F]+-){4}[0-9a-fA-F]+$/)

      # cookies should now be filled with the one created.
      cookies = subject.request.cookies
      expect(cookies.size).to eq(1)

      # We know there's only one cookie here, so just use that for the test.
      aggregate_failures 'cookie structure' do
        # format is [key, value]
        cookie_key = cookies.first[0]
        expect(cookie_key).to start_with(SnowplowRubyDuid::KEY_PREFIX)

        cookie_value = cookies.first[1]
        expect(cookie_value).to be_a(Hash)
        expect(cookie_value[:value]).to start_with(got_userid)
        # Timecop frozen "now" + 2 years
        expect(cookie_value[:expires].to_s.encode('US-ASCII')).to start_with('2027-02-01 10:00:00'.encode('US-ASCII'))
        expect(cookie_value[:domain]).to eq('.example.com')
        expect(cookie_value[:path]).to eq('/')
        expect(cookie_value[:same_site]).to eq(:lax)
      end
    end
  end
end

# What we're testing is a Mixin, so mix it in to something we control
# the methods that the Mixin uses (cookies, request.cookies, request.host).  We don't
# need ACTUAL Grape things here, just things that act the same way.
class GrapeHelperSpecTestApp
  include SnowplowRubyDuid::GrapeHelper

  attr_reader :request

  def initialize
    @request = Struct.new(:cookies, :host).new({}, 'example.com')
  end

  def cookies = @request.cookies
end
