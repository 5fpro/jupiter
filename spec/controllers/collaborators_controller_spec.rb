require 'rails_helper'

RSpec.describe CollaboratorsController, type: :request do
  let!(:project) { FactoryBot.create :project_has_members }
  let!(:user) { project.owner }
  let(:user2) { project.users.last }

  before do
    signin_user(user)
  end

  it '#index' do
    get "/projects/#{project.id}/collaborators"
    expect(response).to be_successful
  end

  it '#new' do
    get "/projects/#{project.id}/collaborators/new"
    expect(response).to be_successful
  end

  it '#edit' do
    get "/projects/#{project.id}/collaborators/edit"
    expect(response).to be_successful
  end

  describe '#update' do
    let(:params) { attributes_for(:project_for_update, :project_users) }

    it 'success' do
      put "/projects/#{project.id}/collaborators", params: { project: params }
      expect(response).to be_redirect
      expect(project.project_users.last.reload.wage).to be_present
    end

    context 'fail' do
      before { project.update_column :name, '' }

      it do
        put "/projects/#{project.id}/collaborators", params: { project: params }
        expect(response).to be_successful
      end
    end
  end

  it '#create' do
    user = FactoryBot.create :user
    expect {
      post "/projects/#{project.id}/collaborators", params: { project_user: { email: user.email } }
    }.to change { project.users.count }.by(1)
    expect(response).to redirect_to("/projects/#{project.id}/collaborators")
    follow_redirect!
    expect(response).to be_successful
  end

  it '#destroy' do
    project_user = project.project_users.last
    expect {
      delete "/projects/#{project.id}/collaborators/#{project_user.id}"
    }.to change { project.users.count }.by(-1)
    expect(response).to redirect_to("/projects/#{project.id}/collaborators")
    follow_redirect!
    expect(response).to be_successful
  end

end
