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
  let!(:user) { FactoryBot.create :user }
  let!(:project) { FactoryBot.create :project_has_records, owner: user }
  let!(:record) { project.records.last }

  before { signin_user(user) }

  context 'under /' do
    context 'GET /records' do
      before { get '/records' }

      it { expect(response).to be_successful }

      it { expect(response.body).not_to match(/action="\/projects\/#{project.id}\/records"/) }

      it { expect(response.body).to match(/action="\/records"/) }

      context 'different groups' do
        let!(:project) { FactoryBot.create :project_has_members, owner: user }
        let(:member) { project.users.last }

        before { FactoryBot.create :record, project: project, user: member }

        before { FactoryBot.create :record, project: project, user: user, record_type: :meeting }

        before { FactoryBot.create :record, user: user, record_type: :meeting }

        before { FactoryBot.create :record, :with_todo, user: user, record_type: :meeting }

        it 'by project' do
          get '/records', params: { q: { group_with: 'project' } }
          expect(response).to be_successful
        end

        it 'by record_type' do
          get '/records', params: { q: { group_with: 'record_type' } }
          expect(response).to be_successful
        end

        it 'by week' do
          get '/records', params: { q: { group_with: 'week' } }
          expect(response).to be_successful
        end

        it 'by user' do
          get '/records', params: { q: { user_id_eq: member.id } }
          expect(response).to be_successful
        end

        it 'by todo' do
          get '/records', params: { q: { group_with: 'todo' } }
          expect(response).to be_successful
        end
      end

    end
  end

  context 'under /projects/:project_id' do

    it 'not my project' do
      project2 = FactoryBot.create :project
      expect {
        get "/projects/#{project2.id}/records"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    describe '#share' do
      subject { get "/projects/#{project.id}/records/share" }

      before { FactoryBot.create :record, project: project, user: user }

      context 'success with signed in' do
        before { subject }

        it { expect(response).to be_successful }
      end

      context 'success with signed out' do
        before { signout_user }

        before { subject }

        it { expect(response).to be_successful }
      end

      context 'csv' do
        subject { get "/projects/#{project.id}/records/share.csv" }

        before { subject }

        it { expect(response).to be_successful }
      end
    end

    describe '#index' do

      subject { get "/projects/#{project.id}/records" }

      context 'empty' do
        before { subject }

        it { expect(response).to be_successful }

        it { expect(response.body).to match(/action="\/projects\/#{project.id}\/records"/) }
      end

      context 'has record' do
        before { FactoryBot.create :record, project: project, user: user }

        before { subject }

        it { expect(response).to be_successful }
      end

      context 'by user' do
        let!(:record2) { FactoryBot.create(:record, note: '4567') }

        before { get '/records', params: { q: { user_id_eq: record2.user.id } } }

        it { expect(response).to be_successful }
        it { expect(response.body).to match(record2.note) }
      end

      context 'different groups' do
        let!(:project) { FactoryBot.create :project_has_members, :with_records, owner: user }
        let(:member) { project.users.last }

        before { FactoryBot.create :record, project: project, user: member }

        before { FactoryBot.create :record, project: project, user: user, record_type: :meeting }

        before { FactoryBot.create :record, user: user, record_type: :meeting }

        it 'by user' do
          get "/projects/#{project.id}/records", params: { q: { group_with: 'user' } }
          expect(response).to be_successful
        end

        it 'by record_type' do
          get "/projects/#{project.id}/records", params: { q: { group_with: 'record_type' } }
          expect(response).to be_successful
        end

        it 'by week' do
          get "/projects/#{project.id}/records", params: { q: { group_with: 'week' } }
          expect(response).to be_successful
        end
      end
    end

    describe '#show' do
      let!(:project) { FactoryBot.create :project_has_members, :with_records, owner: user }
      let(:member) { project.users.last }

      context 'my record' do
        before { get "/projects/#{project.id}/records/#{record.id}" }

        it { expect(response).to be_successful }
      end

      context 'not my record' do
        let(:record2) { FactoryBot.create :record, project: project, user: member }

        before { get "/projects/#{project.id}/records/#{record2.id}" }

        it { expect(response).to be_successful }
      end

      context 'not project record' do
        let(:record2) { FactoryBot.create :record, user: member }

        it { expect { get "/projects/#{project.id}/records/#{record2.id}" }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      context 'not my record of outside project member' do
        let(:record2) { FactoryBot.create :record }

        it { expect { get "/projects/#{project.id}/records/#{record2.id}" }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end

    describe '#new' do
      context 'can find not done todo' do
        before { FactoryBot.create :todo, :pending, project: project, user: user, desc: '我愛羅' }

        it 'html' do
          get "/projects/#{project.id}/records/new"
          expect(response.body).to match('我愛羅')
        end

        it 'js' do
          get "/projects/#{project.id}/records/new.js", xhr: true
          expect(response.body).to match('我愛羅')
        end
      end

      it 'html' do
        get "/projects/#{project.id}/records/new"
        expect(response).to be_successful
      end

      it 'js' do
        get "/projects/#{project.id}/records/new.js", xhr: true
        expect(response).to be_successful
      end
    end

    describe '#create' do
      it 'html' do
        expect {
          post "/projects/#{project.id}/records", params: { record: attributes_for(:record) }
        }.to change(Record, :count).by(1)
        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful
      end

      it 'js' do
        expect {
          post "/projects/#{project.id}/records", params: { record: attributes_for(:record) }, xhr: true
        }.to change(Record, :count).by(1)
        expect(response).to be_successful
      end
    end

    describe '#edit' do
      let!(:project) { FactoryBot.create :project_has_members, :with_records, owner: user }
      let(:member) { project.users.last }

      context 'my record' do
        before { get "/projects/#{project.id}/records/#{record.id}/edit" }

        it { expect(response).to be_successful }
      end

      context 'not my record' do
        let(:record2) { FactoryBot.create :record, project: project, user: member }

        it { expect { get "/projects/#{project.id}/records/#{record2.id}/edit" }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      context 'not project record' do
        let(:record2) { FactoryBot.create :record, user: member }

        it { expect { get "/projects/#{project.id}/records/#{record2.id}/edit" }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      context 'not my record of outside project member' do
        let(:record2) { FactoryBot.create :record }

        it { expect { get "/projects/#{project.id}/records/#{record2.id}/edit" }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end

    describe '#update' do
      let(:params) { attributes_for(:record_for_params) }

      it do
        expect {
          put "/projects/#{project.id}/records/#{record.id}", params: { record: params }
        }.to change { record.reload.minutes }.to(params[:minutes])
        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful
      end
    end

    it '#destroy' do
      expect {
        delete "/projects/#{project.id}/records/#{record.id}"
      }.to change(Record, :count).by(-1)
      expect(response).to be_redirect
      follow_redirect!
      expect(response).to be_successful
    end
  end

end
