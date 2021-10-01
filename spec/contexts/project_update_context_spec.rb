require 'rails_helper'

describe ProjectUpdateContext do
  subject { described_class.new(user, project).perform(data) }

  let(:user) { FactoryBot.create :user }
  let(:user1) { FactoryBot.create :user }
  let(:data) { attributes_for(:project_for_update, :setting) }
  let!(:project) { FactoryBot.create :project, :with_project_user, owner: user }

  context 'success' do
    it { expect(subject.name).to eq(data[:name]) }
    it { expect(subject.price_of_hour).to eq(data[:price_of_hour]) }
    it { expect(subject.hours_limit).to eq(data[:hours_limit]) }
    it { expect(subject.description).to eq(data[:description]) }
  end

  context 'not owner' do
    subject { described_class.new(user1, project).perform(data) }

    it { expect { subject }.not_to change(project, :name) }
    it { expect { subject }.not_to change(project, :price_of_hour) }
    it { expect { subject }.not_to change(project, :hours_limit) }
    it { expect { subject }.not_to change(project, :description) }
  end
end
