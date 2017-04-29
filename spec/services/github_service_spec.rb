require 'rails_helper'

RSpec.describe GithubService, type: :model do

  # describe "#orgs" do
  #   subject { described_class.new("token").orgs }

  #   it { expect(subject.first.login).to eq("5fpro") }
  # end

  # describe "#repos_by_org" do
  #   subject { described_class.new("token").repos_by_org("5fpro") }

  #   it { expect(subject.first.name).to eq("titto") }
  # end

  describe "#collect_all_repos" do
    subject { described_class.new("token").collect_all_repos }

    it { expect(subject.first).to eq("5fpro/chef_explorer") }
  end

  describe "#create_hook" do
    subject { described_class.new("token").create_hook("xxx/repo", "hook_url") }

    it { expect(subject.id.present?).to be_truthy }
  end

  # describe "#show_hook" do
  #   subject { described_class.new("token").show_hook("xxx/repo", 99_999) }

  #   it { expect(subject.id.present?).to be_truthy }
  # end

  describe "#delete_hook" do
    subject { described_class.new("token").delete_hook("xxx/repo", 99_999) }

    it { expect(subject).to be_truthy }
  end

end
