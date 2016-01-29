require 'rails_helper'

RSpec.describe ProjectsController, type: :request do

  let!(:project) { project_created! }
  let(:user) { @user }

  def remove_user_from_project!(project, user)
    project.project_users.where(user_id: user.id).first.try(:delete)
  end

  before { signin_user(user) }

  describe "#index" do

    subject { get "/projects" }

    context "empty" do
      before { Project.delete_all }
      before { subject }

      it { expect(response).to be_success }
    end

    context "has projects & records" do
      before { project_created!(current_user) }
      before { record_created!(current_user, project) }
      before { record_created!(current_user, project) }

      before { subject }

      it { expect(response).to be_success }
    end
  end

  describe "#show" do
    subject { get "/projects/#{project.id}" }

    context "empty" do
      before { subject }

      it { expect(response).to be_success }
    end

    context "has member" do
      let(:member) { FactoryGirl.create :user }

      before { project_invite!(project, member) }
      before { subject }

      it { expect(response).to be_success }

      context "has reocrds" do
        let(:time) { (50 * 60) + 10 }

        before { FactoryGirl.create :record, project: project, user: member, minutes: time, created_at: 1.minute.ago }
        before { get "/projects/#{project.id}" }

        it { expect(response.body).to match(DatetimeService.to_units_text(time.minutes, skip_day: true)) }
      end

    end

    context "not in project" do
      before { remove_user_from_project!(project, user) }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  it "#new" do
    get "/projects/new"
    expect(response).to be_success
  end

  it "#create" do
    expect {
      post "/projects", project: data_for(:project)
    }.to change { Project.count }.by(1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

  describe "#edit" do
    subject { get "/projects/#{project.id}/edit" }

    context "success" do
      before { subject }

      it { expect(response).to be_success }
    end

    context "not in project" do
      before { remove_user_from_project!(project, user) }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#update" do
    let(:data) { data_for(:update_project) }
    subject { put "/projects/#{project.id}", project: data }

    context "success" do
      before { subject }

      it { expect(response).to be_redirect }

      context "follow redirect" do
        before { follow_redirect! }

        it { expect(response).to be_success }
      end
    end

    context "not in project" do
      before { remove_user_from_project!(project, user) }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "update fail" do
      before { project.update_column :name, "" }
      before { subject }

      it { expect(response).to be_success }
      it { expect(project.reload.description).to be_blank }
    end
  end

  describe "#setting" do
    subject { get "/projects/#{project.id}/setting" }

    context "success" do
      before { subject }
      it { expect(response).to be_success }
    end

    context "not owner" do
      before { project.update_attribute :owner, nil }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#update_setting" do
    let(:data) { data_for(:update_project_setting) }
    subject { put "/projects/#{project.id}/setting", project: data }

    context "success" do
      before { subject }
      it { expect(response).to be_redirect }
    end

    context "not owner" do
      before { project.update_attribute :owner, nil }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "update fail" do
      let!(:data) { data_for(:update_project_setting, name: "") }
      before { subject }

      it { expect(response).to be_success }
    end
  end
end
