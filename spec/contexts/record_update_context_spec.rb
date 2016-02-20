require 'rails_helper'

describe RecordUpdateContext do
  let(:record) { FactoryGirl.create(:record) }
  let(:project) { record.project }
  let(:user) { record.user }
  let(:params) { attributes_for(:record_for_params) }

  subject { described_class.new(user, record) }

  it "success" do
    expect {
      subject.perform(params)
    }.to change { record.reload.note }.to(params[:note])
  end

  context "not owner" do
    let(:user1) { FactoryGirl.create :user }

    subject { described_class.new(user1, record) }

    it do
      expect {
        subject.perform(params)
      }.not_to change { record.reload.note }
    end
  end

  describe "#calculate_todo" do
    let(:todo) { FactoryGirl.create :todo, total_time: 1234, project: project }

    context "nil -> int" do
      let(:params) { { todo_id: todo.id } }
      it { expect { subject.perform(params) }.to change { todo.reload.total_time } }
    end

    context "int -> nil" do
      let(:params) { { todo_id: nil } }
      before { record.update_attribute :todo_id, todo.id }
      it { expect { subject.perform(params) }.to change { todo.reload.total_time }.to(0) }
    end

    context "int -> int" do
      let!(:todo2) { FactoryGirl.create :todo, project: project }
      let(:params) { { todo_id: todo2.id } }
      before { record.update_attribute :todo_id, todo.id }
      it { expect { subject.perform(params) }.to change { todo.reload.total_time }.to(0) }
      it { expect { subject.perform(params) }.to change { todo2.reload.total_time }.to(record.total_time) }
    end
  end
end
