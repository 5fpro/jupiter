require 'rails_helper'

describe Notify::GenerateMessageContext do
  context 'event = record_created' do
    let(:record) { FactoryGirl.create :record }
    subject { described_class.new(:record_created, record: record) }

    it { expect(subject.perform).to be_present }
    it { expect(subject.perform).not_to match('translation missing') }
  end
end
