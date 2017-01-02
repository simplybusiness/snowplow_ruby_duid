module SnowplowRubyDuid
  describe Cookie do
    before do
      @host               = 'www.simplybusiness.co.uk'
      @domain_userid      = 'domain_user_id'
      @request_created_at = (DateTime.parse '2015-01-22 15:26:31 +0000').to_time
    end

    subject { described_class.new @host, @domain_userid, @request_created_at }

    describe '#key' do
      it 'generates the key' do
        expect(subject.key).to eq('_sp_id.8fb9')
      end
    end

    describe '#value' do
      it 'generates a cookie' do
        expect(subject.value).to eq(
          domain:  '.simplybusiness.co.uk',
          expires: (DateTime.parse '2017-01-22 15:26:31 +0000').to_time,
          path:    '/',
          value:   'domain_user_id.1421940391.0.1421940391.'
        )
      end
    end

    it 'runs the feature' do
      feature
    end

    step 'the host is :host' do |host|
      @host = host
    end

    step 'the domain_userid is :domain_userid' do |domain_userid|
      @domain_userid = domain_userid
    end

    step 'the time is :time' do |time|
      @request_created_at = (DateTime.parse time).to_time
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

    step 'the cookie value for :field is :value' do |field, value|
      value_index = case field
                    when 'domain_userid'
                      then 0
                    when 'createTs'
                      then 1
                    when 'visitCount'
                      then 2
                    when 'nowTs'
                      then 3
                    when 'lastVisitTs'
                      then 4
                    else
                      raise "unknown field name: #{field}"
      end

      value = nil if value == ''

      values = subject.value[:value].split '.'
      expect(values[value_index]).to eq(value)
    end
  end
end
