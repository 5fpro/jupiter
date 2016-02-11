# == Schema Information
#
# Table name: records
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  project_id  :integer
#  minutes     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  data        :hstore
#  record_type :integer
#

require 'rails_helper'

RSpec.describe RecordsController, type: :request do
  let!(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project, :with_project_user, owner: user }
  let!(:record) { record_created!(user, project) }
  before { signin_user(user) }

  context "under /" do
    context "GET /records" do
      before { get "/records" }

      it { expect(response).to be_success }

      it { expect(response.body).not_to match(/action="\/projects\/#{project.id}\/records"/) }

      it { expect(response.body).to match(/action="\/records"/) }

      context "different groups" do

        let(:member) { FactoryGirl.create :user }
        before { project_invite!(project, member) }
        before { FactoryGirl.create :record, project: project, user: member }
        before { FactoryGirl.create :record, project: project, user: user, record_type: :meeting }
        before { FactoryGirl.create :record, user: user, record_type: :meeting }

        it "by project" do
          get "/records", q: { group_by: "project" }
          expect(response).to be_success
        end

        it "by record_type" do
          get "/records", q: { group_by: "record_type" }
          expect(response).to be_success
        end

        it "by week" do
          get "/records", q: { group_by: "week" }
          expect(response).to be_success
        end
      end

    end
  end

  context "under /projects/:project_id" do

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

        it { expect(response.body).to match(/action="\/projects\/#{project.id}\/records"/) }
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
        before { FactoryGirl.create :record, user: user, record_type: :meeting }

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
        let(:record2) { FactoryGirl.create :record }

        it { expect { get "/projects/#{project.id}/records/#{record2.id}" }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end

    describe "#new" do
      it "html" do
        get "/projects/#{project.id}/records/new"
        expect(response).to be_success
      end
      it "js" do
        xhr :get, "/projects/#{project.id}/records/new.js"
        expect(response).to be_success
      end
    end

    describe "#create" do
      it "html" do
        expect {
          post "/projects/#{project.id}/records", record: attributes_for(:record)
        }.to change { Record.count }.by(1)
        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_success
      end
      it "js" do
        expect {
          xhr :post, "/projects/#{project.id}/records", record: attributes_for(:record)
        }.to change { Record.count }.by(1)
        expect(response).to be_success
      end
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

        it { expect { get "/projects/#{project.id}/records/#{record2.id}/edit" }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      context "not my record of outside project member" do
        let(:record2) { FactoryGirl.create :record }

        it { expect { get "/projects/#{project.id}/records/#{record2.id}/edit" }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end

    it "#update" do
      expect {
        put "/projects/#{project.id}/records/#{record.id}", record: attributes_for(:record, :update_record)
      }.to change { record.reload.minutes }.to(attributes_for(:record, :update_record)[:minutes])
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

end
