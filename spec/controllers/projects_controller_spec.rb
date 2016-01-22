require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  before do
    project_created!
    signin_user(@user)
  end

  it "#index" do
    get "/projects"
    expect(response).to be_success
  end

  it "#show" do
    get "/projects/#{@project.id}"
    expect(response).to be_success
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
