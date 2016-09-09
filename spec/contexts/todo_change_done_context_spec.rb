require 'rails_helper'

describe TodoChangeDoneContext do
  subject { described_class.new(todo, status) }

  context "to finished" do
    let(:todo) { FactoryGirl.create :todo, :with_records, :doing }
    let(:status) { "finished" }
    it { expect { subject.perform }.to change { todo.reload.finished? }.to(true) }
  end

  context "to processing" do
    let(:todo) { FactoryGirl.create :todo, :with_records, :finished }
    let(:status) { "doing" }
    it { expect { subject.perform }.to change { todo.reload.doing? }.to(true) }
  end

  context "to pending" do
    let(:todo) { FactoryGirl.create :todo, :with_records, :doing }
    let(:status) { "pending" }
    it { expect { subject.perform }.to change { todo.reload.pending? }.to(true) }
  end

  context "to pending if no reocrds" do
    let(:todo) { FactoryGirl.create :todo, :doing }
    let(:status) { "finished" }
    it { expect { subject.perform }.not_to change { todo.reload.status } }
  end

  describe "#update_todo_last_recorded_at" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, :doing }
    let(:status) { "finished" }
    before { Timecop.freeze 1.hour.from_now }
    it { expect { subject.perform }.to change { todo.reload.last_recorded_at } }
  end

  context "remove sort if finished" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, :doing }
    let(:status) { "finished" }
    before { todo.insert_at(1) }

    it { expect { subject.perform }.to change { todo.reload.sort }.to(nil) }
  end

  context "remove sort if pending" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, :doing, sort: 1 }
    let(:status) { "pending" }
    before { todo.insert_at(1) }

    it { expect { subject.perform }.to change { todo.reload.sort }.to(nil) }

    context 'status = nil will not change sort and status' do
      let(:status) { nil }
      before { todo.insert_at(1) }
      it { expect { subject.perform }.not_to change { todo.reload.sort } }
    end
  end

  context "add sort finished to doing" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, :finished }
    let(:status) { "doing" }

    it { expect { subject.perform }.to change { todo.reload.sort }.to(1) }
  end

  context "add sort pending to processing" do
    let!(:todo) { FactoryGirl.create :todo, :with_records }
    let(:status) { "doing" }

    it { expect { subject.perform }.to change { todo.reload.sort }.to(1) }
  end
end
