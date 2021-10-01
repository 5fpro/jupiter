require 'rails_helper'

describe RecordUpdateContext do
  subject { described_class.new(user, record) }

  let(:record) { FactoryBot.create(:record) }
  let(:user) { record.user }
  let(:params) { attributes_for(:record_for_params) }

  it 'success' do
    expect {
      subject.perform(params)
    }.to change { record.reload.note }.to(params[:note])
  end

  context 'not owner' do
    subject { described_class.new(user1, record) }

    let(:user1) { FactoryBot.create :user }

    it do
      expect {
        subject.perform(params)
      }.not_to change { record.reload.note }
    end
  end

  describe '#calculate_todo' do
    subject { described_class.new(user, record).perform(params) }

    let!(:record) { FactoryBot.create(:record, :with_todo) }
    let(:params) { attributes_for(:record_for_params) }
    let(:todo) { Todo.last }

    it { expect { subject }.to change { todo.reload.total_time } }
  end
end
