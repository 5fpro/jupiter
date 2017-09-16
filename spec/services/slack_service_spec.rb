require 'rails_helper'

RSpec.describe SlackService, type: :model do
  it ".notify" do
    described_class.notify("haha")
  end

  it ".notify_admin" do
    expect {
      described_class.notify_admin("haha")
    }.to have_enqueued_job(SlackNotifyJob)
  end

  it ".notify_async" do
    expect {
      described_class.notify_async("haha")
    }.to have_enqueued_job(SlackNotifyJob)
  end
end
