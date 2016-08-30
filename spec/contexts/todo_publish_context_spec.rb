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

  context 'todo scopes' do
    def add_record(todo)
      RecordCreateContext.new(user, todo.project).perform(FactoryGirl.attributes_for(:record_for_params, todo_id: todo.id))
      expect(todo.reload.last_recorded_on).to be_present
    end

    def to_not_done(todo)
      TodoChangeDoneContext.new(todo, "nil").perform
      expect(todo).to be_not_done
    end

    def to_processing(todo)
      TodoChangeDoneContext.new(todo, false).perform
      expect(todo).to be_processing
    end

    def invite_user_to_project(user, project)
      project.project_users.create(user: user)
    end

    let(:todo) { FactoryGirl.create(:todo, :not_done, user: user) }
    before { invite_user_to_project(user, todo.project) }

    context 'no record -> processing' do
      before { to_processing(todo) }
      before { subject.perform }

      it { expect(subject.today_processing_todos.map(&:id)).not_to be_include(todo.id) }
      it { expect(subject.processing_todos.map(&:id)).to be_include(todo.id) }
    end

    context 'processing -> no record -> not_done' do
      before { to_processing(todo) }
      before { to_not_done(todo) }
      before { subject.perform }

      it { expect(subject.today_processing_todos.map(&:id)).not_to be_include(todo.id) }
      it { expect(subject.processing_todos.map(&:id)).not_to be_include(todo.id) }
    end

    context 'processing -> has record' do
      before { to_processing(todo) }
      before { add_record(todo) }
      before { subject.perform }
      it { expect(subject.today_processing_todos.map(&:id)).to be_include(todo.id) }
      it { expect(subject.processing_todos.map(&:id)).to be_include(todo.id) }
    end

    context 'processing -> has record -> not_done' do
      before { to_processing(todo) }
      before { add_record(todo) }
      before { to_not_done(todo) }
      before { subject.perform }

      it { expect(subject.today_processing_todos.map(&:id)).to be_include(todo.id) }
      it { expect(subject.processing_todos.map(&:id)).not_to be_include(todo.id) }
    end
  end
end
