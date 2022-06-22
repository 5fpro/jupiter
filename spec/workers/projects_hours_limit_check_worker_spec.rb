require 'rails_helper'

RSpec.describe ProjectsHoursLimitCheckWorker, type: :worker do
  subject { described_class.new.perform }

  before { FactoryBot.create :project }

  it { expect { subject }.to have_enqueued_job(Project::HoursLimitCheckJob) }
end
