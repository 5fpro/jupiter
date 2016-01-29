require 'rails_helper'

RSpec.describe SlackService, type: :model do
  it ".notify" do
    described_class.notify("haha")
  end

  it ".notify_admin" do
    described_class.notify_admin("haha")
  end

  it ".notify_async" do
    expect {
      described_class.notify_async("haha")
    }.to change_sidekiq_jobs_size_of(SlackService, :notify)
  end
end
