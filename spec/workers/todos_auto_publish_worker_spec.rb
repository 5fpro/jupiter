require 'rails_helper'

RSpec.describe TodosAutoPublishWorker, type: :worker do
  let(:user) { FactoryGirl.create :user }
  subject { described_class.new }

  context "empty record" do
    it { expect { subject.perform }.not_to change_sidekiq_jobs_size_of(TodoPublishContext, :perform) }  
  end

  context "has todo & record" do
    let!(:todo) { FactoryGirl.create :todo, :with_records, user: user }
    let!(:done_todo) { FactoryGirl.create :todo, :with_records, user: user, done: true }

    it { expect { subject.perform }.to change_sidekiq_jobs_size_of(TodoPublishContext, :perform) }

  end
end 
