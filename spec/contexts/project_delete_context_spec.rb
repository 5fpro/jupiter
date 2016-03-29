require 'rails_helper'

describe ProjectDeleteContext do
  let(:user) { FactoryGirl.create :user }
  let(:user1) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project_has_members, owner: user}
  let(:project_has_todos) { FactoryGirl.create :project_has_todos, owner: user}

  subject { described_class.new(user, project) }

  it "success" do
    expect {
      subject.perform
    }.to change { user.projects.count }.by(-1)
  end

  it "not owner" do
    expect {
      described_class.new(user1, project).perform
    }.not_to change { project.records.count }
  end

  it "has todo" do 
    expect {
      described_class.new(user, project_has_todos).perform
    }.not_to change { project.records.count }    
  end
    
end  