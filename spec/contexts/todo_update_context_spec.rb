require 'rails_helper'

describe TodoUpdateContext do
  let(:project) { FactoryGirl.create :project, :with_project_user }
  let(:user) { project.owner }
  let(:todo) { FactoryGirl.create :todo, user: user }

  subject { described_class.new(todo, params) }

  context 'success' do
    let(:params) { attributes_for(:todo_for_params, desc: 'blablabla') }

    it { expect { subject.perform }.to change { todo.reload.desc }.to(params[:desc]) }
  end

  context 'validates_project!' do
    let(:params) { attributes_for(:todo_for_params, :has_project_id) }

    it { expect { subject.perform }.not_to change { todo.project } }
  end

  describe '#sorting' do
    let(:todo) { FactoryGirl.create :todo, :doing, user: user }
    let(:params) { attributes_for(:todo_for_params, sort: :remove) }
    before { todo.insert_at(1) }
    it { expect { subject.perform }.to change { todo.reload.sort }.to(nil) }
  end
end
