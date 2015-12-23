require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  let(:project_user){ FactoryGirl.create :project_user }

  it "FactoryGirl" do
    expect(project_user).not_to be_new_record
  end
end
