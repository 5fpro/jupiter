require 'rails_helper'

RSpec.describe CollaboratorsController, type: :request do
  before do
    project_created!
    signin_user(@user)
  end

  it "#index" do
    get "/projects/#{@project.id}/collaborators"
    expect(response).to be_success
  end

  it "#new" do
    get "/projects/#{@project.id}/collaborators/new"
    expect(response).to be_success
  end

  it "#edit" do
    get "/projects/#{@project.id}/collaborators/edit"
    expect(response).to be_success
  end

  it "#create" do
    user = FactoryGirl.create :user
    expect {
      post "/projects/#{@project.id}/collaborators", project_user: { email: user.email }
    }.to change { @project.users.count }.by(1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

  it "#destroy" do
    project_invite!(@project)
    project_user = @project.project_users.where(user_id: @user.id).first
    expect {
      delete "/projects/#{@project.id}/collaborators/#{project_user.id}"
    }.to change { @project.users.count }.by(-1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

end
