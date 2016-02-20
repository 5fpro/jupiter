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
end
