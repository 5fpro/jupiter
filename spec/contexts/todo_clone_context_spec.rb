require 'rails_helper'

describe TodoCloneContext do
  let(:todo) { FactoryGirl.create :todo, :done, desc: "123" }
  subject { described_class.new(todo) }

  context "success" do
    it { expect { subject.perform }.to change { todo.user.todos.count }.by(1) }
    it { expect { subject.perform }.to change { todo.project.todos.count }.by(1) }
    it { expect(subject.perform.desc).to eq todo.desc }
    it { expect(subject.perform.original_id).to eq todo.id }
    context "fail" do
      let(:todo) { FactoryGirl.create :todo }
      it { expect { subject.perform }.not_to change { todo.user.todos.count } }
      it { expect(subject.perform).to eq false }
    end
  end
end
