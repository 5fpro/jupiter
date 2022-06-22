require 'rails_helper'

describe RecordDeleteContext do
  subject { described_class.new(user, record) }

  let(:user) { FactoryBot.create :user }
  let(:user1) { FactoryBot.create :user }
  let!(:project) { FactoryBot.create :project_has_records, owner: user }
  let(:record) { project.records.last }

  it 'success' do
    expect {
      subject.perform
    }.to change { project.records.count }.by(-1)
  end

  it 'not owner' do
    expect {
      described_class.new(user1, record).perform
    }.not_to change { project.records.count }
  end

  describe '#calculate_todo' do
    let!(:todo) { FactoryBot.create :todo, :finished, total_time: 123, project: project }

    before { record.update_attribute :todo, todo }

    it { expect { subject.perform }.to change { todo.reload.total_time }.to(0) }
    it { expect { subject.perform }.to change { todo.reload.doing? }.to(true) }
    it { expect { subject.perform }.to change { todo.reload.last_recorded_on }.to(nil) }
    it { expect { subject.perform }.to change { todo.reload.last_recorded_at }.to(nil) }
  end
end
