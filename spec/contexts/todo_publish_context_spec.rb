require 'rails_helper'

describe TodoPublishContext, type: :context do
  subject { described_class.new(user) }

  let(:user) { FactoryBot.create(:user) }

  it 'empty' do
    expect {
      subject.perform
    }.to enqueue_job(SlackNotifyJob)
  end

  context 'has todo & record' do
    let!(:todo) { FactoryBot.create :todo, :with_records, user: user }
    let!(:done_todo) { FactoryBot.create :todo, :finished, :with_records, user: user }

    it do
      expect {
        subject.perform
      }.to enqueue_job(SlackNotifyJob)
    end
  end

  describe '#update_user_todos_published' do
    it { expect { subject.perform }.to change { user.reload.todos_published? }.to(true) }

    context 'skip_user_update' do
      it { expect { subject.perform(skip_user_update: true) }.not_to change { user.reload.todos_published? } }
    end
  end

  context 'todo scopes' do
    def add_record(todo)
      RecordCreateContext.new(user, todo.project).perform(FactoryBot.attributes_for(:record_for_params, todo_id: todo.id))
      expect(todo.reload.last_recorded_on).to be_present
    end

    def to_pending(todo)
      TodoChangeStatusContext.new(todo, 'pending').perform
      expect(todo).to be_pending
    end

    def to_doing(todo)
      TodoChangeStatusContext.new(todo, 'doing').perform
      expect(todo).to be_doing
    end

    def invite_user_to_project(user, project)
      project.project_users.create(user: user)
    end

    let(:todo) { FactoryBot.create(:todo, :pending, user: user) }

    before { invite_user_to_project(user, todo.project) }

    context 'no record -> doing' do
      before { to_doing(todo) }

      before { subject.perform }

      it { expect(subject.today_doing_todos.map(&:id)).not_to be_include(todo.id) }
      it { expect(subject.doing_todos.map(&:id)).to be_include(todo.id) }
    end

    context 'doing -> no record -> pending' do
      before { to_doing(todo) }

      before { to_pending(todo) }

      before { subject.perform }

      it { expect(subject.today_doing_todos.map(&:id)).not_to be_include(todo.id) }
      it { expect(subject.doing_todos.map(&:id)).not_to be_include(todo.id) }
    end

    context 'doing -> has record' do
      before { to_doing(todo) }

      before { add_record(todo) }

      before { subject.perform }

      it { expect(subject.today_doing_todos.map(&:id)).to be_include(todo.id) }
      it { expect(subject.doing_todos.map(&:id)).to be_include(todo.id) }
    end

    context 'doing -> has record -> pending' do
      before { to_doing(todo) }

      before { add_record(todo) }

      before { to_pending(todo) }

      before { subject.perform }

      it { expect(subject.today_doing_todos.map(&:id)).to be_include(todo.id) }
      it { expect(subject.doing_todos.map(&:id)).not_to be_include(todo.id) }
    end
  end
end
