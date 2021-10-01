require 'rails_helper'

describe ProjectDeleteContext do
  let(:user) { FactoryBot.create :user }
  let!(:project) { FactoryBot.create :project_has_members, owner: user }

  describe '#perform' do
    context 'success' do
      subject { described_class.new(user, project) }

      it { expect { subject.perform }.to change { user.projects.count }.by(-1) }
    end

    context 'not owner' do
      subject { described_class.new(user1, project) }

      let(:user1) { FactoryBot.create :user }

      it { expect { subject.perform }.not_to change { project.records.count } }
    end

    context 'has todo' do
      subject { described_class.new(user, project_has_todos) }

      let(:project_has_todos) { FactoryBot.create :project_has_todos, owner: user }

      it { expect { subject.perform }.not_to change { project.records.count } }
    end

  end
end
