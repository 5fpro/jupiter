require 'rails_helper'

describe TodoDeleteContext do
  subject { described_class.new(todo) }

  let(:todo) { FactoryBot.create :todo }
  let(:user) { todo.user }

  context 'success' do
    it { expect { subject.perform }.to change { user.todos.count }.by(-1) }
  end

  context 'validates_done_yet' do
    let(:todo) { FactoryBot.create :todo, :finished }

    it { expect { subject }.not_to change { user.todos.count } }
  end
end
