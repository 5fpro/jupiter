require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment){ FactoryGirl.create :comment }

  it "FactoryGirl" do
    expect(comment).not_to be_new_record
  end
end
