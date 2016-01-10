require 'rails_helper'

RSpec.describe RecordsController, type: :request do
  let!(:project) { FactoryGirl.create :project }
  let!(:record) { FactoryGirl.create :record, project: project }

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
      post "/projects/#{project.id}/records", records: data_for(:record)
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
      put "/projects/#{project.id}/records/#{record.id}", records: { minutes: 10 }
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

  it "#histories" do
    get "/projects/#{project.id}/records/histories"
    expect(response).to be_success
  end
end
