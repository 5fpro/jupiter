require 'rails_helper'

RSpec.describe ProjectsHoursLimitCheckWorker, type: :worker do
  before { FactoryGirl.create :project }
  subject { described_class.new.perform }

  it { expect { subject }.to change_sidekiq_jobs_size_of(Project::HoursLimitCheckContext, :perform) }
end
