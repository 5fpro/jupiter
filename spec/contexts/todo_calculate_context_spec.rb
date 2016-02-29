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
    it { expect { subject.perform }.to change { todo.reload.done? }.to(true) }
  end
end
