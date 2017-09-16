require 'rails_helper'

RSpec.describe ProjectsHoursLimitCheckWorker, type: :worker do
  before { FactoryGirl.create :project }
  subject { described_class.new.perform }

  it { expect { subject }.to have_enqueued_job(Project::HoursLimitCheckJob) }
end
