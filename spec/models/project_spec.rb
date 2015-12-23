require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project){ FactoryGirl.create :project }

  it "FactoryGirl" do
    expect(project).not_to be_new_record
  end
end
