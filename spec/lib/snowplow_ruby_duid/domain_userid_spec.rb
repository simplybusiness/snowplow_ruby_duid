module SnowplowRubyDuid
  describe DomainUserid do
    let(:request_env) do
      {
        'HTTP_ACCEPT'          => 'accept',
        'HTTP_USER_AGENT'      => 'user_agent',
        'HTTP_ACCEPT_ENCODING' => 'accept_encoding',
        'HTTP_ACCEPT_LANGUAGE' => 'accept_language',
      }
    end
    before { set_the_request_created_at_time '2015-01-22 15:26:31 +0000' }

    subject { (described_class.new request_env, @request_created_at).to_s }

    describe '#to_s' do
      it 'generates the domain userid' do
        expect(subject).to eq('7e4b7582288e505d')
      end
    end

    it 'runs the feature' do
      feature
    end

    step 'a request environment' do; end

    step 'the time is :time' do |time|
      set_the_request_created_at_time time
    end

    step 'I create a domain userid' do; end

    step 'the domain userid has a length of :length' do |length|
      expect(subject.length).to eq(length.to_i)
    end

    step 'the request environment parameter :parameter_name is set to :parameter_value' do |parameter_name, parameter_value|
      request_env[parameter_name] = parameter_value
    end

    step 'the domain userid is :domain_userid' do |domain_userid|
      expect(subject).to eq(domain_userid)
    end
  end
end

def set_the_request_created_at_time(time)
  @request_created_at = (DateTime.parse time).to_time
end
