require 'rails_helper'

describe RecordCreateContext do
  let(:user) { FactoryGirl.create :user }
  let(:project) { project_created!(user) }
  let(:data) { attributes_for(:record) }

  subject { described_class.new(user, project) }

  it "success" do
    expect {
      subject.perform(data)
    }.to change { project.records.count }.by(1)
    expect {
      subject.perform(data)
    }.to change { project.records.count }.by(1)
  end

  it "#validates_user_in_project!" do
    subject.user = FactoryGirl.create :user
    expect {
      @result = subject.perform(data)
    }.not_to change { project.records.count }
    expect(@result).to eq false
  end

  it "model validates fail" do
    expect {
      subject.perform(data.merge(minutes: nil))
    }.not_to change { project.records.count }
  end

  describe "#notify_slack_channels" do
    before { FactoryGirl.create :slack_channel, :record_created, project: project }

    it { expect { subject.perform(data) }.to change_sidekiq_jobs_size_of(SlackService, :notify).by(1) }
  end
end
