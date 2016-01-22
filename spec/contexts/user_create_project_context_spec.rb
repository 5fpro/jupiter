require 'rails_helper'

describe UserCreateProjectContext do
  let(:user) { FactoryGirl.create :user }
  let(:data) { data_for_project }

  subject { described_class.new(user, data).perform }

  it "success" do
    expect {
      @project = subject
    }.to change { Project.count }
    expect(@project.name).to be_present
  end

  it "be owner" do
    expect {
      subject
    }.to change { user.owned_projects.count }.by(1)
  end

  it "#create_project_users" do
    expect {
      subject
    }.to change { user.projects.count }.by(1)
  end
end
