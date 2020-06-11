# frozen_string_literal: true

module SnowplowRubyDuid
  describe DomainUserid do
    subject { described_class.new.to_s }

    describe '#to_s' do
      it 'generates the domain userid' do
        expect(subject.length).to eq(36)
      end
    end
  end
end
