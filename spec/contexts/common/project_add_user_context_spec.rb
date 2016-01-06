require 'rails_helper'

describe Common::ProjectAddUserContext do
  let(:user){ FactoryGirl.create :user }
  let(:project){ FactoryGirl.create :project }

  subject{ described_class.new(project, user).perform }

  it "success" do
    expect{
      subject
    }.to change{ project.reload.has_user?(user) }.to(true)
  end

  it "#update_users_count" do
    expect{
      subject
    }.to change{ project.reload.users_count }.by(1)
  end

  context "#validates_user_not_in_project!" do
    before{ subject }

    it "users_count" do
      expect{
        described_class.new(project, user).perform
      }.not_to change{ project.reload.users_count }
    end
    it "project_users.count" do
      expect{
        described_class.new(project, user).perform
      }.not_to change{ project.reload.project_users.count }
    end
  end
end
