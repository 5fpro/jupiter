require 'rails_helper'

describe TodoCreateContext do
  let(:project) { FactoryGirl.create :project, :with_project_user }
  let(:user) { project.owner }

  subject { described_class.new(user, params) }

  context 'success' do
    let(:params) { attributes_for(:todo_for_params, project_id: project.id) }

    it { expect { subject.perform }.to change { user.todos.count }.by(1) }
    it { expect(subject.perform.desc).to eq(params[:desc]) }
  end

  context 'validates_project!' do
    let(:params) { attributes_for(:todo_for_params, :has_project_id) }

    it { expect { subject.perform }.not_to change { user.todos.count } }
  end
end
