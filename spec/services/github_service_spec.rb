require 'rails_helper'

RSpec.describe GithubService, type: :model do

  describe "#orgs" do
    subject { described_class.new("token").orgs }

    it { expect(subject.first.login).to eq("5fpro") }
  end

  describe "#orgs" do
    subject { described_class.new("token").repos_by_org("5fpro") }

    it { expect(subject.first.name).to eq("titto") }
  end

  describe "#all_repos" do
    subject { described_class.new("token").all_repos }

    it { expect(subject.first.name).to eq("chef_explorer") }
  end

  describe "#auto_create_hook" do
    subject { described_class.new("token").auto_create_hook("repo", "hook_url") }

    it { expect(subject.id.present?).to be_truthy }
  end

  describe "#show_hook" do
    subject { described_class.new("token").show_hook("repo", 99_999) }

    it { expect(subject.id.present?).to be_truthy }
  end

  describe "#auto_delete_hook" do
    subject { described_class.new("token").auto_delete_hook("repo", 99_999) }

    it { expect(subject).to be_truthy }
  end

end
