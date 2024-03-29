# == Schema Information
#
# Table name: todos
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  project_id       :integer
#  desc             :text
#  last_recorded_on :date
#  data             :hstore
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  last_recorded_at :datetime
#  sort             :integer
#  status           :integer
#

require 'rails_helper'

RSpec.describe TodosController, type: :request do
  let!(:user) { FactoryBot.create :user }

  before { signin_user(user) }

  context 'GET /todos' do
    context 'empty' do
      before { get '/todos' }

      it { expect(response).to be_successful }
    end

    context 'has todo' do
      let!(:todo) { FactoryBot.create :todo, user: user }

      before { get '/todos' }

      it { expect(response).to be_successful }
    end
  end

  context 'GET /todos/new.js' do
    subject { get '/todos/new.js', xhr: true }

    before { subject }

    it { expect(response).to be_successful }

    context 'with :project_id' do
      subject { get '/todos/new.js', params: { project_id: project.id }, xhr: true }

      let!(:project) { FactoryBot.create :project }

      it { expect(response).to be_successful }
    end
  end

  context 'GET /todos/123/edit.js' do
    subject { get "/todos/#{todo.id}/edit.js", xhr: true }

    let!(:todo) { FactoryBot.create :todo, user: user }

    context 'success' do
      before { subject }

      it { expect(response).to be_successful }
    end

    context 'not my todo' do
      let!(:todo) { FactoryBot.create :todo }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  context 'POST /todos.js' do
    subject { post '/todos.js', params: { todo: params }, xhr: true }

    let!(:project) { FactoryBot.create :project, :with_project_user, owner: user }
    let(:params) { attributes_for(:todo_for_params, project_id: project.id) }

    context 'success' do
      before { subject }

      it { expect(response).to be_successful }
      it { expect(Todo.count).to be > 0 }
    end

    context 'not in project' do
      let!(:project) { FactoryBot.create :project }

      it { expect { subject }.not_to change(Todo, :count) }
    end
  end

  context 'PUT /todos/123.js' do
    subject { put "/todos/#{todo.id}.js", params: { todo: { desc: '123' } }, xhr: true }

    let!(:todo) { FactoryBot.create :todo, user: user }

    context 'success' do
      before { subject }

      it { expect(response).to be_successful }
      it { expect(todo.reload.desc).to eq '123' }
    end

    context 'not my todo' do
      let!(:todo) { FactoryBot.create :todo }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  context 'DELETE /todos/123.js' do
    subject { delete "/todos/#{todo.id}.js", xhr: true }

    let!(:todo) { FactoryBot.create :todo, user: user }

    context 'success' do
      before { subject }

      it { expect(response).to be_successful }
      it { expect(Todo.count).to eq 0 }
    end

    context 'not my todo' do
      let!(:todo) { FactoryBot.create :todo }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  context 'POST /todos/123/change_status.js' do
    subject { post "/todos/#{todo.id}/change_status.js", params: { status: status }, xhr: true }

    context 'finished change to doing' do
      let(:status) { 'doing' }
      let!(:todo) { FactoryBot.create :todo, :finished, user: user }

      it { expect { subject }.to change { todo.reload.finished? }.to(false) }
    end

    context 'pending change to doing' do
      let(:status) { 'doing' }
      let!(:todo) { FactoryBot.create :todo, user: user }

      it { expect { subject }.to change { todo.reload.doing? }.to(true) }
    end

    context 'doing change to pending' do
      let(:status) { 'pending' }
      let!(:todo) { FactoryBot.create :todo, :doing, user: user }

      it { expect { subject }.to change { todo.reload.pending? }.to(true) }
    end

    context 'doing change to finished' do
      let(:status) { 'finished' }
      let!(:todo) { FactoryBot.create :todo, :with_records, :doing, user: user }

      it { expect { subject }.to change { todo.reload.finished? }.to(true) }
    end

    context 'pending change to finished' do
      let(:status) { 'finished' }
      let!(:todo) { FactoryBot.create :todo, :with_records, user: user }

      it { expect { subject }.to change { todo.reload.finished? }.to(true) }
    end

    context 'fail without record' do
      let(:status) { 'finished' }
      let!(:todo) { FactoryBot.create :todo, :doing, user: user }

      it { expect { subject }.not_to change { todo.reload.finished? } }
    end

    context 'not my todo' do
      let(:status) { 'finished' }
      let!(:todo) { FactoryBot.create :todo, :doing }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  context 'POST /todos/publish' do
    subject { post '/todos/publish', headers: { 'HTTP_REFERER' => '/todos' } }

    before { subject }

    it { expect(response).to redirect_to('/todos') }
  end

end
