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
#  todo_id     :integer
#

require 'rails_helper'

RSpec.describe RecordsController, type: :request do
  let!(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project_has_records, owner: user }
  let!(:record) { project.records.last }
  before { signin_user(user) }

  context "under /" do
    context "GET /records" do
      before { get "/records" }

      it { expect(response).to be_success }

      it { expect(response.body).not_to match(/action="\/projects\/#{project.id}\/records"/) }

      it { expect(response.body).to match(/action="\/records"/) }

      context "different groups" do
        let!(:project) { FactoryGirl.create :project_has_members, owner: user }
        let(:member) { project.users.last }
        before { FactoryGirl.create :record, project: project, user: member }
        before { FactoryGirl.create :record, project: project, user: user, record_type: :meeting }
        before { FactoryGirl.create :record, user: user, record_type: :meeting }
        before { FactoryGirl.create :record, :with_todo, user: user, record_type: :meeting }

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

        it "by user" do
          get "/records", q: { user_id_eq: member.id }
          expect(response).to be_success
        end

        it "by todo" do
          get "/records", q: { group_by: "todo" }
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

    describe "#share" do
      subject { get "/projects/#{project.id}/records/share" }
      before { FactoryGirl.create :record, project: project, user: user }
      context "success with signed in" do
        before { subject }
        it { expect(response).to be_success }
      end
      context "success with signed out" do
        before { signout_user }
        before { subject }
        it { expect(response).to be_success }
      end
      context "csv" do
        subject { get "/projects/#{project.id}/records/share.csv" }
        before { subject }
        it { expect(response).to be_success }
      end
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

      context "by user" do
        let!(:record2) { FactoryGirl.create(:record, note: "4567") }
        before { get "/records", q: { user_id_eq: record2.user.id } }
        it { expect(response).to be_success }
        it { expect(response.body).to match(record2.note) }
      end

      context "different groups" do
        let!(:project) { FactoryGirl.create :project_has_members, :with_records, owner: user }
        let(:member) { project.users.last }

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
      let!(:project) { FactoryGirl.create :project_has_members, :with_records, owner: user }
      let(:member) { project.users.last }

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
      context "can find not done todo" do
        before { FactoryGirl.create :todo, :pending, project: project, user: user, desc: "我愛羅" }

        it "html" do
          get "/projects/#{project.id}/records/new"
          expect(response.body).to match("我愛羅")
        end

        it "js" do
          xhr :get, "/projects/#{project.id}/records/new.js"
          expect(response.body).to match("我愛羅")
        end
      end
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
      let!(:project) { FactoryGirl.create :project_has_members, :with_records, owner: user }
      let(:member) { project.users.last }

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

    describe "#update" do
      let(:params) { attributes_for(:record_for_params) }
      it do
        expect {
          put "/projects/#{project.id}/records/#{record.id}", record: params
        }.to change { record.reload.minutes }.to(params[:minutes])
        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_success
      end
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
