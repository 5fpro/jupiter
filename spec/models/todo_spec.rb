# == Schema Information
#
# Table name: todos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  desc       :text
#  date       :date
#  data       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:todo) { FactoryGirl.create :todo }

  context "FactoryGirl" do
    it { expect(todo).not_to be_new_record }
  end

  describe ".for_bind" do
    let!(:todo1) { FactoryGirl.create :todo, date: nil }
    let!(:todo2) { FactoryGirl.create :todo, date: Time.now.to_date }
    let!(:todo3) { FactoryGirl.create :todo, date: 1.day.ago }
    let!(:todo4) { FactoryGirl.create :todo, date: 1.day.from_now }

    subject { described_class.for_bind.map(&:id) }

    it { expect(subject).to be_include(todo1.id) }
    it { expect(subject).to be_include(todo2.id) }
    it { expect(subject).not_to be_include(todo3.id) }
    it { expect(subject).not_to be_include(todo4.id) }
  end

  describe "has many records" do
    let(:todo) { FactoryGirl.create :todo, :with_records }

    it "destroy dependent" do
      record = todo.records.last
      expect {
        todo.destroy
      }.to change { record.reload.todo }.to(nil)
    end
  end
end
