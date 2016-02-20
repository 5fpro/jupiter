require 'rails_helper'

describe RecordCreateContext do
  let(:project) { FactoryGirl.create :project, :with_project_user }
  let(:user) { project.owner }
  let(:data) { attributes_for(:record_for_params) }

  subject { described_class.new(user, project) }

  it "success" do
    expect {
      subject.perform(data)
    }.to change { project.records.count }.by(1)
    expect {
      subject.perform(data)
    }.to change { project.records.count }.by(1)
  end

  describe "#validates_user_in_project!" do
    let(:user) { FactoryGirl.create :user }
    it { expect { subject.perform(data) }.not_to change { project.records.count } }
    it { expect(subject.perform(data)).to eq false }
  end

  context "model validates fail" do
    let(:params) { data.merge(minutes: nil) }
    it { expect { subject.perform(data.merge(minutes: nil)) }.not_to change { project.records.count } }
  end

  describe "#notify_slack_channels" do
    before { FactoryGirl.create :slack_channel, :record_created, project: project }

    it { expect { subject.perform(data) }.to change_sidekiq_jobs_size_of(SlackService, :notify).by(1) }
  end

  context "has todo" do
    let(:data) { attributes_for(:record_for_params, :has_todo_id) }
    let(:todo) { Todo.find(data[:todo_id]) }

    describe "#copy_note_from_todo_desc" do
      it { expect(subject.perform(data).note).to match(todo.desc) }
    end

    describe "#calculate_todo" do
      it { expect { subject.perform(data) }.to change { todo.reload.total_time } }
      it { expect { subject.perform(data) }.to change { todo.reload.done? }.to(true) }
      it { expect { subject.perform(data) }.to change { todo.reload.date } }
    end
  end

end
