require 'rack'
require 'rack/test'
require 'timecop'

module SnowplowRubyDuid
  describe Helper do
    include Rack::Test::Methods

    describe 'snowplow_domain_userid' do
      let(:app) { App.new }
      before do
        Timecop.freeze(Time.local(1990))
      end
      after do
        Timecop.return
      end
      subject { last_response.header['Set-Cookie'] }

      it 'runs the feature' do
        feature
      end

      step 'I set a Snowplow domain userid of :domain_userid in my cookie' do |domain_userid|
        set_cookie("_sp_id.3678=#{domain_userid}.631152000.0.631152000.631152000") unless domain_userid == ''
      end

      step 'I request the Snowplow domain userid' do
        allow_any_instance_of(DomainUserid).to receive(:to_s).and_return('2222222222222222')
        get '/'
      end

      step 'I receive the Snowplow domain userid :domain_userid' do |domain_userid|
        expect(app.domain_userid).to eq(domain_userid)
      end

      step 'I have the Snowplow domain userid :domain_userid in my cookie' do |domain_userid|
        expect(subject).to include(domain_userid)
      end

      context 'when there is an existing snowplow cookie' do
        before do
          set_cookie('_sp_id.3678=111111111111.631152000.0.631152000.631152000')
        end

        it 'retrieves the domain userid from the cookie' do
          get '/'
          expect(app.domain_userid).to eq('111111111111')
        end

        it 'does not modify the domain userid' do
          get '/'
          expect(subject).to include('111111111111')
        end
      end

      context 'when there is not an existing snowplow cookie' do

        it 'generates a domain userid and saves it in the response cookie' do
          get '/'
          expect(subject).to include(app.domain_userid)
        end
      end
    end
  end
end

class App
  include SnowplowRubyDuid::Helper

  attr_reader :request, :response, :domain_userid

  def call env
    @request  = Rack::Request.new env
    @response = Rack::Response.new
    request.cookies.each{|k,v| response.set_cookie k, v }

    @domain_userid = snowplow_domain_userid

    [response.status, response.header, response.body]
  end
end
