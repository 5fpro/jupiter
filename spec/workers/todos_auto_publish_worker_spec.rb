require 'rails_helper'

RSpec.describe TodosAutoPublishWorker, type: :worker do
  let(:user) { FactoryGirl.create :user }
  subject { described_class.new }

  context 'empty record' do
    it { expect { subject.perform }.not_to enqueue_job(TodosAutoPublishJob) }
  end

  context 'has todo & record' do
    let!(:todo) { FactoryGirl.create :todo, :with_records, user: user }
    let!(:done_todo) { FactoryGirl.create :todo, :with_records, :finished, user: user }

    it do
      count = User.all.reject { |user| user.todos_published? || user.records.today.empty? }.size
      expect {
        subject.perform
      }.to have_enqueued_job(TodosAutoPublishJob).exactly(count)
    end
  end
end
