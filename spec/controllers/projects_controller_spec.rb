# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  price_of_hour :integer
#  name          :string
#  owner_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  data          :hstore
#

require 'rails_helper'

RSpec.describe ProjectsController, type: :request do

  let!(:project) { FactoryGirl.create :project_has_members }
  let(:user) { project.owner }
  let(:user1) { FactoryGirl.create :user }

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
      before { FactoryGirl.create :project_has_records, owner: current_user }

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
      let(:member) { project.users.last }

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
      post "/projects", project: attributes_for(:project)
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

    context "not owner" do
      before { project.update_attribute :owner, user1 }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#update" do
    let(:data) { attributes_for(:project_for_update, :setting) }
    subject { put "/projects/#{project.id}", project: data }

    context "success" do
      before { subject }

      it { expect(response).to be_redirect }

      context "follow redirect" do
        before { follow_redirect! }

        it { expect(response).to be_success }
      end
    end

    context "not owner" do
      before { project.update_attribute :owner, user1 }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "update fail" do
      let!(:data) { attributes_for(:project_for_update, :setting, name: "") }
      before { subject }

      it { expect(response).to be_success }
      it { expect(project.reload.description).to be_blank }
    end
  end

  describe "#edit_collection" do
    subject { get "/projects/edit" }
    before { subject }

    it { expect(response).to be_success }
  end

  describe "#archived" do
    subject { get "/projects/archived" }
    before { subject }

    it { expect(response).to be_success }
  end

  describe "#click_archive" do
    let(:project) { Project.create(data) }
    context "archived to not archived" do
      let(:data) { attributes_for(:project_is_archived) }
      subject { post "/projects/#{project.id}/click_archive", project: data }
      before { subject }

      it { expect(response).to redirect_to(archived_projects_path) }
    end

    context "not archived to archived" do
      let(:data) { attributes_for(:project_is_archived, is_archived: false) }
      subject { post "/projects/#{project.id}/click_archive", project: data }
      before { subject }

      it { expect(response).to redirect_to(edit_projects_path) }
    end
  end

  describe "#destroy" do
    subject { delete "/projects/#{project.id}" }
    it { expect { subject }.to change { Project.count }.by(-1) }
    it { expect(response).to be_redirect }
  end
end
