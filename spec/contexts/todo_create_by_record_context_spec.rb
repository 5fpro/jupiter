require 'rails_helper'

describe TodoCreateByRecordContext do
  let(:record) { FactoryGirl.create :record, note: "123123" }

  subject { described_class.new(record) }

  it { expect { subject.perform }.to change { record.user.todos.count }.by(1) }
  it { expect { subject.perform }.to change { record.project.todos.count }.by(1) }
  it { expect { subject.perform }.to change { record.reload.todo } }
  it { expect(subject.perform.reload.done?).to eq false }
  it { expect(subject.perform.reload.last_recorded_on).to be_present }
  it { expect(subject.perform.reload.last_recorded_at).to be_present }

  context "record desc blank" do
    let(:record) { FactoryGirl.create :record, note: "" }

    it { expect { subject.perform }.not_to change { record.user.todos.count } }
  end
end
