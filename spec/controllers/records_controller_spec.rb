require 'rails_helper'

RSpec.describe RecordsController, type: :request do
  let!(:user) { FactoryGirl.create :user }
  let!(:project) { project_created!(user) }
  let!(:record) { record_created!(user, project) }
  before { signin_user(user) }

  it "not my project" do
    project2 = FactoryGirl.create :project
    expect {
      get "/projects/#{project2.id}/records"
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe "#index" do

    subject { get "/projects/#{project.id}/records" }

    context "empty" do
      before { subject }

      it { expect(response).to be_success }
    end

    context "has record" do
      before { FactoryGirl.create :record, project: project, user: user }
      before { subject }

      it { expect(response).to be_success }
    end

    context "different groups" do

      let(:member) { FactoryGirl.create :user }
      before { project_invite!(project, member) }
      before { FactoryGirl.create :record, project: project, user: member }
      before { FactoryGirl.create :record, project: project, user: user, record_type: :meeting }

      it "by user" do
        get "/projects/#{project.id}/records", q: { group_by: "user" }
        expect(response).to be_success
      end

      it "by record_type" do
        get "/projects/#{project.id}/records", q: { group_by: "record_type" }
        expect(response).to be_success
      end

      it "by week" do
        get "/projects/#{project.id}/records", q: { group_by: "week" }
        expect(response).to be_success
      end
    end
  end

  describe "#show" do
    let(:member) { FactoryGirl.create :user }
    before { project_invite!(project, member) }

    context "my record" do
      before { get "/projects/#{project.id}/records/#{record.id}" }

      it { expect(response).to be_success }
    end

    context "not my record" do
      let(:record2) { FactoryGirl.create :record, project: project, user: member }
      before { get "/projects/#{project.id}/records/#{record2.id}" }

      it { expect(response).to be_success }
    end

    context "not project record" do
      let(:record2) { FactoryGirl.create :record, user: member }

      it { expect { get "/projects/#{project.id}/records/#{record2.id}" }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "not my record of outside project member" do
      let(:record2) { FactoryGirl.create :record, user: member }

      it { expect { get "/projects/#{project.id}/records/#{record2.id}" }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  it "#new" do
    get "/projects/#{project.id}/records/new"
    expect(response).to be_success
  end

  it "#create" do
    expect {
      post "/projects/#{project.id}/records", record: data_for(:record)
    }.to change { Record.count }.by(1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

  describe "#edit" do
    let(:member) { FactoryGirl.create :user }
    before { project_invite!(project, member) }

    context "my record" do
      before { get "/projects/#{project.id}/records/#{record.id}/edit" }

      it { expect(response).to be_success }
    end

    context "not my record" do
      let(:record2) { FactoryGirl.create :record, project: project, user: member }

      it { expect { get "/projects/#{project.id}/records/#{record2.id}/edit" }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "not project record" do
      let(:record2) { FactoryGirl.create :record, user: member }

      it { expect { get "/projects/#{project.id}/records/#{record2.id}" }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "not my record of outside project member" do
      let(:record2) { FactoryGirl.create :record, user: member }

      it { expect { get "/projects/#{project.id}/records/#{record2.id}" }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  it "#update" do
    expect {
      put "/projects/#{project.id}/records/#{record.id}", record: data_for(:update_record)
    }.to change { record.reload.minutes }.to(data_for(:update_record)[:minutes])
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

  it "#destroy" do
    expect {
      delete "/projects/#{project.id}/records/#{record.id}"
    }.to change { Record.count }.by(-1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end
end
