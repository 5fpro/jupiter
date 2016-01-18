require 'rails_helper'

RSpec.describe RecordsController, type: :request do
  let!(:user){ FactoryGirl.create :user }
  let!(:project) { project_created!(user) }
  let!(:record) { record_created!(user, project) }
  before{ signin_user(user) }

  it "not my project" do
    project2 = FactoryGirl.create :project
    expect{
      get "/projects/#{project2.id}/records"
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "#index" do
    get "/projects/#{project.id}/records"
    expect(response).to be_success
  end

  it "#show" do
    get "/projects/#{project.id}/records/#{record.id}"
    expect(response).to be_success
  end

  it "#new" do
    get "/projects/#{project.id}/records/new"
    expect(response).to be_success
  end

  it "#create" do
    expect{
      post "/projects/#{project.id}/records", record: data_for(:record)
    }.to change{ Record.count }.by(1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

  it "#edit" do
    get "/projects/#{project.id}/records/#{record.id}/edit"
    expect(response).to be_success
  end

  it "#update" do
    expect{
      put "/projects/#{project.id}/records/#{record.id}", record: { minutes: 10 }
    }.to change{ record.reload.minutes }
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

  it "#destroy" do
    expect{
      delete "/projects/#{project.id}/records/#{record.id}"
    }.to change{ Record.count }.by(-1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end
end
