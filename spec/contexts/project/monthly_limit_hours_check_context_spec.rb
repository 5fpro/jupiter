require 'rails_helper'

describe Project::MonthlyLimitHoursCheckContext, type: :context do
  let!(:project) { project_created! }
  subject { described_class.new(project) }

  context "success" do
    before { project.update_attribute :monthly_limit_hours, 1 }
    let!(:record) { FactoryGirl.create :record, project: project, minutes: 100 }

    it { expect { subject.perform }.to change { project.reload.approached_monthly_limit_hours }.to(true) }

    context "slack notify" do
      before { FactoryGirl.create :slack_channel, :monthly_limit_hours_approach, project: project }

      it { expect { subject.perform }.to change_sidekiq_jobs_size_of(SlackService, :notify).by(1) }

      context "approached" do
        before { project.update_attribute :approached_monthly_limit_hours, true }

        it { expect { subject.perform }.not_to change_sidekiq_jobs_size_of(SlackService, :notify) }
      end
    end
  end

  context "no value" do
    it { expect(subject.perform).to eq false }
    it { expect { subject.perform }.not_to change { project.reload.approached_monthly_limit_hours } }
  end

  context "not approach" do
    before { project.update_attribute :monthly_limit_hours, 1 }
    let!(:record) { FactoryGirl.create :record, project: project, minutes: 30 }

    it { expect(subject.perform).to eq false }
    it { expect { subject.perform }.not_to change { project.reload.approached_monthly_limit_hours } }
  end
end
