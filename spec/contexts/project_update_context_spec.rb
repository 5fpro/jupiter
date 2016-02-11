require 'rails_helper'

describe ProjectUpdateContext do
  let(:user) { FactoryGirl.create :user }
  let(:user1) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create :project, :with_project_user, owner: user }
  let(:data) { attributes_for(:project_for_update, :member) }
  subject { described_class.new(user, project) }

  it "success" do
    expect {
      subject.perform(data)
    }.to change { project.reload.description }
  end

  context "not in project" do
    subject { described_class.new(user1, project) }

    it { expect { subject.perform(data) }.not_to change { project.reload.description } }
  end
end
