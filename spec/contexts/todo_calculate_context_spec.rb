require 'rails_helper'

describe TodoCalculateContext do
  let!(:todo) { FactoryGirl.create :todo, :with_records }
  subject { described_class.new(todo) }

  it { expect { subject.perform }.to change { todo.reload.total_time } }

  context "reduce record" do
    before { subject.perform }
    before { todo.records.last.destroy }
    it { expect { subject.perform }.to change { todo.reload.total_time } }
  end

  describe "#calculate_last_recorded_time" do
    it { expect { subject.perform }.to change { todo.reload.last_recorded_on } }
    it { expect { subject.perform }.to change { todo.reload.last_recorded_at } }
  end

  describe "#set_done" do
    context "not set" do
      let!(:todo) { FactoryGirl.create :todo, :with_records, done: true }
      it { expect { subject.perform }.not_to change { todo.reload.done? } }
    end

    context "true" do
      it { expect { subject.perform(done: true) }.to change { todo.reload.done? }.to(true) }
    end

    context "false" do
      let!(:todo) { FactoryGirl.create :todo, :with_records, done: true }
      it { expect { subject.perform(done: false) }.to change { todo.reload.done? }.to(false) }
    end

    context "true but not reocrds" do
      let(:todo) { FactoryGirl.create :todo }
      it { expect { subject.perform(done: true) }.not_to change { todo.reload.done? } }
    end
  end
end
