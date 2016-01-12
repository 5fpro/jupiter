require 'rails_helper'

describe ProjectUpdateSettingContext do
  let(:user){ FactoryGirl.create :user }
  let(:user1){ FactoryGirl.create :user }
  before { project_created!(user)}

  it "success" do
    expect{
      described_class.new(user, @project).perform(data_for(:update_project))
    }.to change{ @project.reload.name }
    expect( @project.price_of_hour ).to eq(data_for(:update_project)[:price_of_hour])
  end

  it "not owner" do
    expect{
      described_class.new(user1, @project).perform(data_for(:update_project))
    }.not_to change{ @project.reload.name }
    expect( @project.price_of_hour ).not_to eq(data_for(:update_project)[:price_of_hour])
  end
end
