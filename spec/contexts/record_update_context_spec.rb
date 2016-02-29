require 'rails_helper'

describe RecordUpdateContext do
  let(:record) { FactoryGirl.create(:record) }
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
    let(:todo) { FactoryGirl.create :todo, total_time: 1234 }

    context "nil -> int" do
      let(:params) { { todo_id: todo.id } }
      it { expect { subject.perform(params) }.to change { todo.reload.total_time } }
      it { expect { subject.perform(params) }.to change { todo.reload.done? }.to(true) }
    end

    context "int -> nil" do
      let(:todo) { FactoryGirl.create :todo, :done, total_time: 1234 }
      let(:params) { { todo_id: nil } }
      let!(:record) { FactoryGirl.create(:record, todo: todo) }

      it { expect { subject.perform(params) }.to change { todo.reload.total_time }.to(0) }

      context "todo.date & done?" do
        it { expect { subject.perform(params) }.to change { todo.reload.done? }.to(false) }
        it { expect { subject.perform(params) }.to change { todo.reload.date }.to(nil) }
      end
    end

    context "int -> int" do
      let!(:record) { FactoryGirl.create(:record, todo: todo) }
      let!(:todo2) { FactoryGirl.create :todo, :done, date: 1.day.ago.to_date }
      let(:params) { { todo_id: todo2.id } }

      it { expect { subject.perform(params) }.to change { todo.reload.total_time }.to(0) }
      it { expect { subject.perform(params) }.to change { todo2.reload.total_time }.to(record.total_time) }

      context "todo.date & done?" do
        before { todo.update_attribute :date, record.created_at }

        it { expect { subject.perform(params) }.not_to change { todo2.reload.done? } }
        it { expect { subject.perform(params) }.to change { todo2.reload.date }.to(record.created_at.to_date) }
      end
    end
  end
end
