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
#  last_recorded_at :datetime
#  sort             :integer
#  status           :integer
#

require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:todo) { FactoryBot.create :todo }

  context 'FactoryBot' do
    it { expect(todo).not_to be_new_record }
  end

  describe '.for_bind' do
    subject { described_class.for_bind.map(&:id) }

    let!(:todo1) { FactoryBot.create :todo, :doing, last_recorded_at: nil }
    let!(:todo2) { FactoryBot.create :todo, last_recorded_at: Time.zone.now.to_date }
    let!(:todo3) { FactoryBot.create :todo, :finished, last_recorded_at: 1.day.ago }
    let!(:todo4) { FactoryBot.create :todo, :finished, last_recorded_at: 1.day.from_now }
    let!(:todo5) { FactoryBot.create :todo, :finished, last_recorded_at: Time.zone.now.to_date }
    let!(:todo6) { FactoryBot.create :todo, :doing, last_recorded_at: 1.day.from_now }
    let!(:todo7) { FactoryBot.create :todo, :pending, last_recorded_at: Time.zone.now.to_date }
    let!(:todo8) { FactoryBot.create :todo, :pending, last_recorded_at: 1.day.from_now }

    it { expect(subject).to be_include(todo1.id) }
    it { expect(subject).to be_include(todo2.id) }
    it { expect(subject).not_to be_include(todo3.id) }
    it { expect(subject).not_to be_include(todo4.id) }
    it { expect(subject).to be_include(todo5.id) }
    it { expect(subject).to be_include(todo6.id) }
    it { expect(subject).to be_include(todo7.id) }
    it { expect(subject).to be_include(todo8.id) }
  end

  describe '.today_doing_and_not_finished' do
    subject { described_class.today_doing_and_not_finished.map(&:id) }

    let!(:todo1) { FactoryBot.create :todo, :doing, last_recorded_at: nil }
    let!(:todo2) { FactoryBot.create :todo, :pending, last_recorded_at: 1.day.from_now }
    let!(:todo3) { FactoryBot.create :todo, :pending, last_recorded_at: Time.zone.now.to_date }
    let!(:todo4) { FactoryBot.create :todo, :finished, last_recorded_at: Time.zone.now.to_date }
    let!(:todo5) { FactoryBot.create :todo, :doing, last_recorded_at: Time.zone.now.to_date }

    it { expect(subject).not_to be_include(todo1.id) }
    it { expect(subject).not_to be_include(todo2.id) }
    it { expect(subject).to be_include(todo3.id) }
    it { expect(subject).not_to be_include(todo4.id) }
    it { expect(subject).to be_include(todo5.id) }
  end

  describe '.not_today' do
    subject { described_class.not_today.map(&:id) }

    let!(:todo1) { FactoryBot.create :todo, last_recorded_on: nil }
    let!(:todo2) { FactoryBot.create :todo, last_recorded_on: Time.zone.now.to_date }
    let!(:todo3) { FactoryBot.create :todo, last_recorded_on: 1.day.ago }

    it { expect(subject).to be_include(todo1.id) }
    it { expect(subject).not_to be_include(todo2.id) }
    it { expect(subject).to be_include(todo3.id) }
  end

  describe 'has many records' do
    let(:todo) { FactoryBot.create :todo, :with_records }

    it 'destroy dependent' do
      record = todo.records.last
      expect {
        todo.destroy
      }.to change { record.reload.todo }.to(nil)
    end
  end

  describe '#last_recorded_at=' do
    it 'present' do
      expect {
        todo.last_recorded_at = Time.now
      }.to change(todo, :last_recorded_on)
    end

    context 'nil' do
      let(:todo) { FactoryBot.create(:todo, :finished) }

      it { expect { todo.last_recorded_at = nil }.to change(todo, :last_recorded_on).to(nil) }
    end
  end

  describe 'without sort' do
    it { expect(todo).to be_not_in_list }
  end
end
