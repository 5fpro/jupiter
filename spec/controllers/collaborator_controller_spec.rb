require 'rails_helper'

RSpec.describe CollaboratorsController, type: :request do

  let!(:project) { FactoryGirl.create :project }
  let!(:user) { FactoryGirl.create :user }

  it "#index" do
    get "/projects/#{project.id}/collaborators"
    expect(response).to be_success
  end

  it "#new" do
    get "/projects/#{project.id}/collaborators/new"
    expect(response).to be_success
  end

  it "#create" do
    expect{
      post "/projects/#{project.id}/collaborators", project_users: data_for(:project_user, project: project, user: user)
    }.to change{ project.users.count }.by(1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

  it "#destroy" do
    project_user = FactoryGirl.create :project_user, project: project, user: user
    expect{
      delete "/projects/#{project.id}/collaborators/#{project_user.id}"
    }.to change{ project.users.count }.by(-1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

end
