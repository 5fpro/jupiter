require 'rails_helper'

describe TodoDeleteContext do
  let!(:todo) { FactoryGirl.create :todo }
  let!(:user) { todo.user }

  subject { described_class.new(todo) }

  context "success" do
    it { expect { subject.perform }.to change { user.todos.count }.by(-1) }
  end

  context "valid_unbind!" do
    let!(:record) { FactoryGirl.create(:record, todo: todo) }
    it { expect { subject }.not_to change { user.todos.count } }
  end
end
