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
    context "include not_done todo with today record" do
      let!(:today_not_done_todo) { FactoryGirl.create :todo, :with_records, user: user, done: false }
      before { change_todo_status(today_not_done_todo, "not_done") }
      it { expect(subject.today_processing_todos.include?(today_not_done_todo)).to be_truthy }
    end

    context "include processing todo with today record" do
      let!(:today_not_done_todo) { FactoryGirl.create :todo, :with_records, user: user, done: false }
      it { expect(subject.today_processing_todos.include?(today_not_done_todo)).to be_truthy }
    end

    context "not include done todo with today record " do
      let!(:today_done_todo) { FactoryGirl.create :todo, :with_records, user: user, done: true }
      it { expect(subject.today_processing_todos.include?(today_done_todo)).to be_falsey }
    end
  end

  describe "#processing_todos" do
    context "include processing todo" do
      let!(:processing_todo) { FactoryGirl.create :todo, user: user, done: false }
      it { expect(subject.processing_todos.include?(processing_todo)).to be_truthy }
    end

    context "not include done todo" do
      let!(:done_todo) { FactoryGirl.create :todo, user: user, done: true }
      it { expect(subject.today_processing_todos.include?(done_todo)).to be_falsey }
    end
  end
end
