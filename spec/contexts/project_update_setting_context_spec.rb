require 'rails_helper'

describe ProjectUpdateSettingContext do
  let(:user) { FactoryGirl.create :user }
  let(:user1) { FactoryGirl.create :user }
  let(:data) { attributes_for(:project, :update_project_setting) }
  let!(:project) { FactoryGirl.create :project, :with_project_user, owner: user }

  it "success" do
    expect {
      described_class.new(user, project).perform(data)
    }.to change { project.reload.name }
    expect(project.price_of_hour).to eq(data[:price_of_hour])
    expect(project.hours_limit).to eq(data[:hours_limit])
  end

  it "not owner" do
    expect {
      described_class.new(user1, project).perform(data)
    }.not_to change { project.reload.name }
    expect(project.price_of_hour).not_to eq(data[:price_of_hour])
  end
end
