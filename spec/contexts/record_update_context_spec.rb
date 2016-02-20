require 'rails_helper'

describe RecordUpdateContext do
  let(:user) { FactoryGirl.create :user }
  let(:user1) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project_has_records, owner: user }
  let(:record) { project.records.last }
  let(:params) { attributes_for(:record_for_params) }

  it "success" do
    expect {
      described_class.new(user, record).perform(params)
    }.to change { record.reload.note }.to(params[:note])
  end

  it "not owner" do
    expect {
      described_class.new(user1, record).perform(params)
    }.not_to change { record.reload.note }
  end
end
