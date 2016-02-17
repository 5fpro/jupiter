require 'rails_helper'

describe TodoUpdateContext do
  let!(:user) { FactoryGirl.create :user }
  let!(:todo) { FactoryGirl.create :todo, user: user }
  let!(:project) { FactoryGirl.create :project }

  before { FactoryGirl.create :project_user, project: project, user: user }

  context "success" do
    let(:params) { attributes_for(:todo_for_update, :params, desc: "blablabla") }
    subject { described_class.new(todo, params).perform }

    it { expect(subject.desc).to eq(params[:desc]) }
  end

  context "validates_project!" do
    let(:project2) { FactoryGirl.create :project }
    let(:params) { attributes_for(:todo_for_update, :params_with_project, project_id: project2.id) }
    subject { described_class.new(todo, params).perform }

    it { expect { subject }.not_to change { todo.project } }
  end

  # context "validates_desc!" do
  #   let(:params) { attributes_for(:todo_for_update, :params, desc: "") }
  #   subject { described_class.new(todo, params).perform }

  #   it { expect { subject }.not_to change { todo.desc } }
  # end
end
