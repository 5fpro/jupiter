require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:todo) { FactoryGirl.create :todo }

  context "FactoryGirl" do
    it { expect(todo).not_to be_new_record }
  end
end
