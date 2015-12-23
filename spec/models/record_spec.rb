require 'rails_helper'

RSpec.describe Record, type: :model do
  let(:record){ FactoryGirl.create :record }

  it "FactoryGirl" do
    expect(record).not_to be_new_record
  end
end
