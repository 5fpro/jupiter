require 'rails_helper'

describe TodoDeleteContext do
  let!(:user) { FactoryGirl.create :user }
  let!(:todo) { FactoryGirl.create :todo, user: user }

  context "success" do
    subject { described_class.new(todo).perform }

    it { expect { subject }.to change { user.todos.count }.by(-1) }
  end

  context "valid_unbind!" do
    let!(:record) { FactoryGirl.create(:record) }
    before { todo.update_attributes(record_ids: [record.id]) }
    subject { described_class.new(todo).perform }
    it { expect { subject }.not_to change { user.todos.count } }
  end
end
