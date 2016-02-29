require 'rails_helper'

describe TodoPublishContext, type: :context do
  let(:user) { FactoryGirl.create(:user) }
  subject { described_class.new(user) }

  it "empty" do
    expect {
      subject.perform
    }.to change_sidekiq_jobs_size_of(SlackService, :notify)
  end

  context "has todo & record" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, user: user }
    let!(:done_todo) { FactoryGirl.create :todo, :with_records, user: user, done: true }
    it { expect { subject.perform }.to change_sidekiq_jobs_size_of(SlackService, :notify) }
  end
end
