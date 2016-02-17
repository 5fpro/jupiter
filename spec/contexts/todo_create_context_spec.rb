require 'rails_helper'

describe TodoCreateContext do
  let!(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project, :with_project_user, owner: user }

  context "success" do
    let(:params) { attributes_for(:todo_for_create, :params, project_id: project.id) }
    subject { described_class.new(user, params).perform }

    it { expect { subject }.to change { user.todos.count }.by(1) }
    it { expect(subject.desc).to eq(params[:desc]) }
  end

  context "validates_project!" do
    let(:params) { attributes_for(:todo_for_create, :params) }
    subject { described_class.new(user, params).perform }

    it { expect { subject }.not_to change { user.todos.count } }
  end

  context "validates_desc!" do
    let(:params) { attributes_for(:todo_for_create, :params, desc: "") }
    subject { described_class.new(user, params).perform }

    it { expect { subject }.not_to change { user.todos.count } }
  end
end
