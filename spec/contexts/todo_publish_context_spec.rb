require 'rails_helper'

describe TodoPublishContext, type: :context do
  let(:user) { FactoryGirl.create(:user) }
  subject { described_class.new(user) }

  it "empty" do
    expect {
      subject.perform
    }.to change_sidekiq_jobs_size_of(SlackService, :notify)
  end

  context "has todo & record" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, user: user }
    let!(:done_todo) { FactoryGirl.create :todo, :with_records, user: user, done: true }
    it { expect { subject.perform }.to change_sidekiq_jobs_size_of(SlackService, :notify) }
  end

  describe "#update_user_todos_published" do
    it { expect { subject.perform }.to change { user.reload.todos_published? }.to(true) }
    context "skip_user_update" do
      it { expect { subject.perform(skip_user_update: true) }.not_to change { user.reload.todos_published? } }
    end
  end

  describe "#today_processing_todos" do
    let!(:today_not_done_todo) { FactoryGirl.create :todo, :with_records, user: user, done: false }
    let!(:today_done_todo) { FactoryGirl.create :todo, :with_records, user: user, done: true }
    before { TodoCalculateContext.new(today_not_done_todo).perform(done: "nil") }

    it { expect(subject.today_processing_todos.include?(today_not_done_todo)).to be_truthy }
    it { expect(subject.today_processing_todos.include?(today_done_todo)).to be_falsey }
  end

  describe "#processing_todos" do
    let!(:processing_todo) { FactoryGirl.create :todo, user: user, done: false }
    let!(:done_todo) { FactoryGirl.create :todo, user: user, done: true }

    it { expect(subject.processing_todos.include?(processing_todo)).to be_truthy }
    it { expect(subject.today_processing_todos.include?(done_todo)).to be_falsey }
  end
end
