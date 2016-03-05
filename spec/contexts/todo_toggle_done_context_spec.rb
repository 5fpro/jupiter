require 'rails_helper'

describe TodoToggleDoneContext do
  subject { described_class.new(todo) }

  context "to done" do
    let(:todo) { FactoryGirl.create :todo, :with_records, done: false }
    it { expect { subject.perform }.to change { todo.reload.done? }.to(true) }
  end
  context "to not done" do
    let(:todo) { FactoryGirl.create :todo, :with_records, done: true }
    it { expect { subject.perform }.to change { todo.reload.done? }.to(false) }
  end
  context "to not done if no reocrds" do
    let(:todo) { FactoryGirl.create :todo, done: false }
    it { expect { subject.perform }.not_to change { todo.reload.done? } }
  end

  describe "#update_todo_last_recorded_at" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, done: false }
    before { Timecop.freeze 1.hour.from_now }
    it { expect { subject.perform }.to change { todo.reload.last_recorded_at } }
  end

  context "remove sort if done" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, done: false, sort: 1 }
    it { expect { subject.perform }.to change { todo.reload.sort }.to(nil) }
    context "add sort if not done" do
      before { subject.perform }
      it { expect { subject.perform }.to change { todo.reload.sort }.to(1) }
    end
  end
end
