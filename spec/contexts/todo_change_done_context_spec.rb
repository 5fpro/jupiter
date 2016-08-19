require 'rails_helper'

describe TodoChangeDoneContext do
  subject { described_class.new(todo, done) }

  context "to done" do
    let(:todo) { FactoryGirl.create :todo, :with_records, done: false }
    let(:done) { "true" }
    it { expect { subject.perform }.to change { todo.reload.done }.to(true) }
  end

  context "to processing" do
    let(:todo) { FactoryGirl.create :todo, :with_records, done: true }
    let(:done) { "false" }
    it { expect { subject.perform }.to change { todo.reload.done }.to(false) }
  end

  context "to not done" do
    let(:todo) { FactoryGirl.create :todo, :with_records, done: true }
    let(:done) { "nil" }
    it { expect { subject.perform }.to change { todo.reload.done }.to(nil) }
  end

  context "to not done if no reocrds" do
    let(:todo) { FactoryGirl.create :todo, done: false }
    let(:done) { "true" }
    it { expect { subject.perform }.not_to change { todo.reload.done } }
  end

  describe "#update_todo_last_recorded_at" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, done: false }
    let(:done) { "true" }
    before { Timecop.freeze 1.hour.from_now }
    it { expect { subject.perform }.to change { todo.reload.last_recorded_at } }
  end

  context "remove sort if done" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, done: false }
    let(:done) { "true" }
    before { todo.insert_at(1) }

    it { expect { subject.perform }.to change { todo.reload.sort }.to(nil) }
  end

  context "remove sort if not done" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, done: false, sort: 1 }
    let(:done) { "nil" }
    before { todo.insert_at(1) }

    it { expect { subject.perform }.to change { todo.reload.sort }.to(nil) }
  end

  context "add sort done to processing" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, done: true }
    let(:done) { "false" }

    it { expect { subject.perform }.to change { todo.reload.sort }.to(1) }
  end

  context "add sort not_done to processing" do
    let!(:todo) { FactoryGirl.create :todo, :with_records }
    let(:done) { "false" }

    it { expect { subject.perform }.to change { todo.reload.sort }.to(1) }
  end
end
