# frozen_string_literal: true

module SnowplowRubyDuid
  describe Cookie do
    before do
      @host               = 'www.simplybusiness.co.uk'
      @domain_userid      = 'domain_user_id'
      @request_created_at = (Time.parse '2015-01-22 15:26:31 +0000').to_time
      @same_site          = SnowplowRubyDuid::Configuration.same_site
      @secure             = SnowplowRubyDuid::Configuration.secure
    end

    subject {
      described_class.new @host, @domain_userid, @request_created_at, { secure: @secure, same_site: @same_site }
    }

    describe '#key' do
      it 'generates the key' do
        expect(subject.key).to eq('_sp_id.8fb9')
      end
    end

    describe '#value' do
      it 'generates a cookie' do
        expect(subject.value).to eq(
          domain: '.simplybusiness.co.uk',
          expires: (Time.parse '2017-01-22 15:26:31 +0000').to_time,
          path: '/',
          same_site: :lax,
          value: 'domain_user_id.1421940391.0.1421940391.'
        )
      end
    end

    feature do
      step 'the host is :host' do |host|
        @host = host
      end

      step 'the domain_userid is :domain_userid' do |domain_userid|
        @domain_userid = domain_userid
      end

      step 'the time is :time' do |time|
        @request_created_at = (Time.parse time).to_time
      end

      step 'I configure library and set secure cookie to :val' do |setting|
        @secure = (setting == 'true') if %w[true false].include?(setting)
      end

      step 'the cookie\'s secure setting is :set_not_set' do |value|
        if value == 'set'
          expect(subject.value[:secure]).to eq(true)
        else
          expect(subject.value[:secure]).to eq(nil)
        end
      end

      step 'I create a Snowplow cookie' do; end

      step 'the cookie has the path :path' do |path|
        expect(subject.value[:path]).to eq(path)
      end

      step 'the cookie has the domain :domain' do |domain|
        if domain == ''
          expect(subject.value[:domain]).to be_nil
        else
          expect(subject.value[:domain]).to eq(domain)
        end
      end

      step 'the cookie has the name :name' do |name|
        expect(subject.key).to eq(name)
      end

      step 'the cookie expires at :time' do |time|
        expect(subject.value[:expires].to_s).to eq(time)
      end

      step 'the cookie value is :value' do |value|
        expect(subject.value[:value]).to eq(value)
      end

      step 'I configure the library and set same_site to equal :setting' do |setting|
        @same_site = setting.to_sym unless setting.empty?
      end

      step 'the cookie has the SameSite attribute equal to :value' do |value|
        expect(subject.value[:same_site]).to eq(value.to_sym)
      end

      step 'the cookie value for :field is :value' do |field, value|
        value_indices = {
          'domain_userid' => 0,
          'createTs' => 1,
          'visitCount' => 2,
          'nowTs' => 3,
          'lastVisitTs' => 4
        }

        value_index = value_indices.fetch(field)

        value = nil if value == ''

        values = subject.value[:value].split '.'
        expect(values[value_index]).to eq(value)
      end
    end
  end
end
