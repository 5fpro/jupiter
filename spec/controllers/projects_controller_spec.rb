require 'rails_helper'

RSpec.describe ProjectsController, type: :request do

  let!(:project) { project_created! }
  before { signin_user(@user) }

  describe "#index" do

    subject { get "/projects" }

    context "empty" do
      before { Project.delete_all }
      before { subject }

      it { expect(response).to be_success }
    end

    context "has projects & records" do
      before{ project_created!(current_user) }
      before{ record_created!(current_user, project) }
      before{ record_created!(current_user, project) }

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

  it "#edit" do
    get "/projects/#{@project.id}/edit"
    expect(response).to be_success
  end

  it "#update" do
    expect {
      put "/projects/#{@project.id}", project: { name: "blablabla" }
    }.to change { @project.reload.name }
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end
end
