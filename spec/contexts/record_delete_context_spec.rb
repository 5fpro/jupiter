require 'rails_helper'

describe RecordDeleteContext do
  let(:user) { FactoryGirl.create :user }
  let(:user1) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project_has_records, owner: user }
  let(:record) { project.records.last }

  subject { described_class.new(user, record) }

  it "success" do
    expect {
      subject.perform
    }.to change { project.records.count }.by(-1)
  end

  it "not owner" do
    expect {
      described_class.new(user1, record).perform
    }.not_to change { project.records.count }
  end

  describe "#calculate_todo" do
    let!(:todo) { FactoryGirl.create :todo, :done, total_time: 123, project: project }
    before { record.update_attribute :todo, todo }
    it { expect { subject.perform }.to change { todo.reload.total_time }.to(0) }
    it { expect { subject.perform }.to change { todo.reload.done? }.to(false) }
    it { expect { subject.perform }.to change { todo.reload.date }.to(nil) }
  end
end
