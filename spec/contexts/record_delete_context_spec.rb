require 'rails_helper'

describe RecordDeleteContext do
  let(:user) { FactoryGirl.create :user }
  let(:user1) { FactoryGirl.create :user }
  before do
    project_created!(user)
    record_created!(user, @project)
  end

  it "success" do
    expect {
      described_class.new(user, @record).perform
    }.to change { @project.records.count }.by(-1)
  end

  it "not owner" do
    expect {
      described_class.new(user1, @record).perform
    }.not_to change { @project.records.count }
  end
end
