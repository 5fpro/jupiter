require 'rails_helper'

describe ProjectDeleteContext do
  let(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project_has_members, owner: user }

  describe "#perform" do
    context "success" do
      subject { described_class.new(user, project) }
      it { expect { subject.perform }.to change { user.projects.count }.by(-1) }
    end

    context "not owner" do
      let(:user1) { FactoryGirl.create :user }
      subject { described_class.new(user1, project) }
      it { expect { subject.perform }.not_to change { project.records.count } }
    end

    context "has todo" do
      let(:project_has_todos) { FactoryGirl.create :project_has_todos, owner: user }
      subject { described_class.new(user, project_has_todos) }
      it { expect { subject.perform }.not_to change { project.records.count } }
    end

  end
end
