require 'rails_helper'

describe RecordUpdateContext do
  let(:user) { FactoryGirl.create :user }
  let(:user1) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project_has_records, owner: user }
  let(:record) { project.records.last }

  it "success" do
    expect {
      described_class.new(user, record).perform(attributes_for(:record, :update_record))
    }.to change { record.reload.note }.to(attributes_for(:record, :update_record)[:note])
  end

  it "not owner" do
    expect {
      described_class.new(user1, record).perform(attributes_for(:record, :update_record))
    }.not_to change { record.reload.note }
  end
end
