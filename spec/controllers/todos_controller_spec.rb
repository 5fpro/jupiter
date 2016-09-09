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
#  done             :boolean
#  last_recorded_at :datetime
#  sort             :integer
#

require 'rails_helper'

RSpec.describe TodosController, type: :request do
  let!(:user) { FactoryGirl.create :user }
  before { signin_user(user) }

  context "GET /todos" do
    context "empty" do
      before { get "/todos" }
      it { expect(response).to be_success }
    end
    context "has todo" do
      let!(:todo) { FactoryGirl.create :todo, user: user }
      before { get "/todos" }
      it { expect(response).to be_success }
    end
  end

  context "GET /todos/new.js" do
    subject { xhr :get, "/todos/new.js" }
    before { subject }
    it { expect(response).to be_success }

    context "with :project_id" do
      let!(:project) { FactoryGirl.create :project }
      subject { xhr :get, "/todos/new.js", project_id: project.id }
      it { expect(response).to be_success }
    end
  end

  context "GET /todos/123/edit.js" do
    let!(:todo) { FactoryGirl.create :todo, user: user }
    subject { xhr :get, "/todos/#{todo.id}/edit.js" }

    context "success" do
      before { subject }
      it { expect(response).to be_success }
    end

    context "not my todo" do
      let!(:todo) { FactoryGirl.create :todo }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  context "POST /todos.js" do
    let!(:project) { FactoryGirl.create :project, :with_project_user, owner: user }
    let(:params) { attributes_for(:todo_for_params, project_id: project.id) }
    subject { xhr :post, "/todos.js", todo: params }

    context "success" do
      before { subject }
      it { expect(response).to be_success }
      it { expect(Todo.count).to be > 0 }
    end

    context "not in project" do
      let!(:project) { FactoryGirl.create :project }
      it { expect { subject }.not_to change { Todo.count } }
    end
  end

  context "PUT /todos/123.js" do
    let!(:todo) { FactoryGirl.create :todo, user: user }
    subject { xhr :put, "/todos/#{todo.id}.js", todo: { desc: "123" } }
    context "success" do
      before { subject }
      it { expect(response).to be_success }
      it { expect(todo.reload.desc).to eq "123" }
    end

    context "not my todo" do
      let!(:todo) { FactoryGirl.create :todo }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  context "DELETE /todos/123.js" do
    let!(:todo) { FactoryGirl.create :todo, user: user }
    subject { xhr :delete, "/todos/#{todo.id}.js" }
    context "success" do
      before { subject }
      it { expect(response).to be_success }
      it { expect(Todo.count).to eq 0 }
    end

    context "not my todo" do
      let!(:todo) { FactoryGirl.create :todo }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  context "POST /todos/123/change_status.js" do
    subject { xhr :post, "/todos/#{todo.id}/change_status.js", status: status }

    context "finished change to doing" do
      let(:status) { "doing" }
      let!(:todo) { FactoryGirl.create :todo, :finished, user: user }
      it { expect { subject }.to change { todo.reload.finished? }.to(false) }
    end

    context "pending change to doing" do
      let(:status) { "doing" }
      let!(:todo) { FactoryGirl.create :todo, user: user }

      it { expect { subject }.to change { todo.reload.doing? }.to(true) }
    end

    context "doing change to pending" do
      let(:status) { "pending" }
      let!(:todo) { FactoryGirl.create :todo, :doing, user: user }

      it { expect { subject }.to change { todo.reload.pending? }.to(true) }
    end

    context "doing change to done" do
      let(:status) { "finished" }
      let!(:todo) { FactoryGirl.create :todo, :with_records, :doing, user: user }

      it { expect { subject }.to change { todo.reload.finished? }.to(true) }
    end

    context "pending change to finished" do
      let(:status) { "finished" }
      let!(:todo) { FactoryGirl.create :todo, :with_records, user: user }

      it { expect { subject }.to change { todo.reload.finished? }.to(true) }
    end

    context "fail without record" do
      let(:status) { "finished" }
      let!(:todo) { FactoryGirl.create :todo, :doing, user: user }
      it { expect { subject }.not_to change { todo.reload.finished? } }
    end

    context "not my todo" do
      let(:status) { "finished" }
      let!(:todo) { FactoryGirl.create :todo, :doing }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  context "POST /todos/publish" do
    subject { post "/todos/publish", nil, "HTTP_REFERER" => "/todos" }
    before { subject }
    it { expect(response).to redirect_to("/todos") }
  end

end
