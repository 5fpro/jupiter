require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  before do
    @project = project_created!
    signin_user(@user)
  end

  it "#index" do
    get "/projects"
    expect(response).to be_success
  end

  describe "#show" do

    let(:project) { @project }

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
