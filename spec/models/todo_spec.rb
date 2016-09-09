# == Schema Information
#
# Table name: todos
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  project_id       :integer
#  desc             :text
#  last_recorded_on :date
#  data             :hstore
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  done             :boolean          default(FALSE)
#  last_recorded_at :datetime
#

require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:todo) { FactoryGirl.create :todo }

  context "FactoryGirl" do
    it { expect(todo).not_to be_new_record }
  end

  describe ".for_bind" do
    let!(:todo1) { FactoryGirl.create :todo, :doing, last_recorded_at: nil }
    let!(:todo2) { FactoryGirl.create :todo, last_recorded_at: Time.zone.now.to_date }
    let!(:todo3) { FactoryGirl.create :todo, :finished, last_recorded_at: 1.day.ago }
    let!(:todo4) { FactoryGirl.create :todo, :finished, last_recorded_at: 1.day.from_now }
    let!(:todo5) { FactoryGirl.create :todo, :finished, last_recorded_at: Time.zone.now.to_date }
    let!(:todo6) { FactoryGirl.create :todo, :doing, last_recorded_at: 1.day.from_now }
    let!(:todo7) { FactoryGirl.create :todo, :pending, last_recorded_at: Time.zone.now.to_date }
    let!(:todo8) { FactoryGirl.create :todo, :pending, last_recorded_at: 1.day.from_now }
    subject { described_class.for_bind.map(&:id) }

    it { expect(subject).to be_include(todo1.id) }
    it { expect(subject).to be_include(todo2.id) }
    it { expect(subject).not_to be_include(todo3.id) }
    it { expect(subject).not_to be_include(todo4.id) }
    it { expect(subject).to be_include(todo5.id) }
    it { expect(subject).to be_include(todo6.id) }
    it { expect(subject).to be_include(todo7.id) }
    it { expect(subject).to be_include(todo8.id) }
  end

  describe ".not_today" do
    let!(:todo1) { FactoryGirl.create :todo, last_recorded_on: nil }
    let!(:todo2) { FactoryGirl.create :todo, last_recorded_on: Time.zone.now.to_date }
    let!(:todo3) { FactoryGirl.create :todo, last_recorded_on: 1.day.ago }

    subject { described_class.not_today.map(&:id) }

    it { expect(subject).to be_include(todo1.id) }
    it { expect(subject).not_to be_include(todo2.id) }
    it { expect(subject).to be_include(todo3.id) }
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

  describe "#last_recorded_at=" do
    it "present" do
      expect {
        todo.last_recorded_at = Time.now
      }.to change { todo.last_recorded_on }
    end
    context "nil" do
      let(:todo) { FactoryGirl.create(:todo, :finished) }
      it { expect { todo.last_recorded_at = nil }.to change { todo.last_recorded_on }.to(nil) }
    end
  end

  describe "without sort" do
    it { expect(todo.not_in_list?).to be_truthy }
  end
end
