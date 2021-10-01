require 'rails_helper'

RSpec.describe TodosAutoPublishWorker, type: :worker do
  subject { described_class.new }

  let(:user) { FactoryBot.create :user }

  context 'empty record' do
    it { expect { subject.perform }.not_to enqueue_job(TodosAutoPublishJob) }
  end

  context 'has todo & record' do
    let!(:todo) { FactoryBot.create :todo, :with_records, user: user }
    let!(:done_todo) { FactoryBot.create :todo, :with_records, :finished, user: user }

    it do
      count = User.all.reject { |user| user.todos_published? || user.records.today.empty? }.size
      expect {
        subject.perform
      }.to have_enqueued_job(TodosAutoPublishJob).exactly(count)
    end
  end
end
