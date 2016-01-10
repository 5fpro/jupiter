require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  let!(:project) { FactoryGirl.create :project }

  it "#index" do
    get "/projects"
    expect(response).to be_success
  end

  it "#show" do
    get "/projects/#{project.id}"
    expect(response).to be_success
  end

  it "#new" do
    get "/projects/new"
    expect(response).to be_success
  end

  it "#create" do
    expect{
      post "/projects", projects: data_for(:project)
    }.to change{ Project.count }.by(1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

  it "#edit" do
    get "/projects/#{project.id}/edit"
    expect(response).to be_success
  end

  it "#update" do
    expect{
      put "/projects/#{project.id}", projects: { name: "blablabla" }
    }.to change{ project.reload.name }
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end
end
