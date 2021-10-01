require 'rails_helper'

describe TodoCalculateContext do
  subject { described_class.new(todo) }

  let!(:todo) { FactoryBot.create :todo, :with_not_calculate_record }

  it { expect { subject.perform }.to change { todo.reload.total_time } }

  context 'reduce record' do
    before { subject.perform }

    before { todo.records.last.destroy }

    it { expect { subject.perform }.to change { todo.reload.total_time } }
  end

  describe '#calculate_last_recorded_time' do
    it { expect { subject.perform }.to change { todo.reload.last_recorded_on } }
    it { expect { subject.perform }.to change { todo.reload.last_recorded_at } }
  end

  describe '#change_status' do
    context 'not set' do
      let!(:todo) { FactoryBot.create :todo, :with_records, :doing }

      it { expect { subject.perform }.not_to change { todo.reload.status } }
    end

    context 'to_finished' do
      it { expect { subject.perform(status: 'finished') }.to change { todo.reload.finished? }.to(true) }
    end

    context 'to_doing' do
      let!(:todo) { FactoryBot.create :todo, :with_records, :finished }

      it { expect { subject.perform(status: 'doing') }.to change { todo.reload.doing? }.to(true) }
    end

    context 'to_pending' do
      let!(:todo) { FactoryBot.create :todo, :with_records, :doing }

      it { expect { subject.perform(status: 'pending') }.to change { todo.reload.pending? }.to(true) }
    end

    context 'to_finished but not reocrds' do
      let(:todo) { FactoryBot.create :todo }

      it { expect { subject.perform(status: 'finished') }.not_to change { todo.reload.status } }
    end
  end
end
