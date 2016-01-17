require 'rails_helper'

describe RecordUpdateContext do
  let(:user){ FactoryGirl.create :user }
  let(:user1){ FactoryGirl.create :user }
  before do
    project_created!(user)
    record_created!(user, @project)
  end

  it "success" do
    expect{
      described_class.new(user, @record).perform(data_for(:update_record))
    }.to change{ @record.reload.note }.to(data_for(:update_record)[:note])
  end

  it "not owner" do
    expect{
      described_class.new(user1, @record).perform(data_for(:update_record))
    }.not_to change{ @record.reload.note }
  end
end
