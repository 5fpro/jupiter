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
    let!(:record) { FactoryGirl.create(:record, :with_todo) }
    let(:params) { attributes_for(:record_for_params) }
    let(:todo) { Todo.last }
    subject { described_class.new(user, record).perform(params) }

    it { expect{ subject }.to change{ todo.reload.total_time } }
  end
end
