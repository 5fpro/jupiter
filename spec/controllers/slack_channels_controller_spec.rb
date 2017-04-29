# == Schema Information
#
# Table name: slack_channels
#
#  id         :integer          not null, primary key
#  project_id :integer
#  disabled   :boolean          default(FALSE)
#  data       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe SlackChannelsController, type: :request do
  before { signin_user }
  let!(:project) { FactoryGirl.create :project, :with_project_user, owner: current_user }
  let(:slack_channel) { FactoryGirl.create :slack_channel, project: project }

  def remove_project_user!(project, user)
    project.project_users.where(user_id: user.id).first.try(:destroy)
  end

  def remove_project_owner!(project)
    project.update_column :owner_id, nil
  end

  describe "#index" do
    subject { get "/projects/#{project.id}/slack_channels" }

    context "empty" do
      before { subject }
      it { expect(response).to be_success }
    end

    context "has data" do
      before { slack_channel }
      before { subject }
      it { expect(response.body).to match(slack_channel.name) }
    end

    context "not my project" do
      before { remove_project_user!(project, current_user) }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#show" do
    subject { get "/projects/#{project.id}/slack_channels/#{slack_channel.id}" }

    context "success" do
      before { subject }
      it { expect(response).to be_success }
    end

    context "not my project" do
      before { remove_project_user!(project, current_user) }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#new" do
    subject { get "/projects/#{project.id}/slack_channels/new" }

    context "success" do
      before { subject }
      it { expect(response).to be_success }
    end

    context "not my project" do
      before { remove_project_user!(project, current_user) }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#edit" do
    subject { get "/projects/#{project.id}/slack_channels/#{slack_channel.id}/edit" }

    context "success" do
      before { subject }
      it { expect(response).to be_success }
    end

    context "not my project" do
      before { remove_project_user!(project, current_user) }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#create" do
    let(:data) { attributes_for :slack_channel_for_create }
    subject { post "/projects/#{project.id}/slack_channels/", slack_channel: data }

    context "success" do
      before { subject }
      it { expect(response).to be_redirect }

      it "follow redirect" do
        follow_redirect!
        expect(response).to be_success
      end

      describe "with primary" do
        let(:data) { attributes_for :slack_channel_for_create, primary: '1' }
        it { expect(SlackChannel.last.primary?).to eq(true) }
      end
    end

    context "fail" do
      before { remove_project_owner!(project) }
      before { subject }
      it { expect(response).to be_success }
    end
  end

  describe "#edit" do
    let(:data) { { name: "venus" } }
    subject { put "/projects/#{project.id}/slack_channels/#{slack_channel.id}", slack_channel: data }

    context "success" do
      before { subject }
      it { expect(response).to be_redirect }

      it "follow redirect" do
        follow_redirect!
        expect(response).to be_success
      end

      it "updated" do
        expect(slack_channel.reload.name).to eq data[:name]
      end
    end

    context "fail" do
      before { remove_project_owner!(project) }
      before { subject }
      it { expect(response).to be_success }
    end
  end

  describe "#destroy" do
    subject { delete "/projects/#{project.id}/slack_channels/#{slack_channel.id}" }

    context "success" do
      before { subject }
      it { expect(response).to be_redirect }

      it "follow redirect" do
        follow_redirect!
        expect(response).to be_success
      end

      it "deleted" do
        expect(project.slack_channels.count).to eq 0
      end
    end

    context "fail" do
      before { remove_project_owner!(project) }
      before { subject }
      it { expect(response).to be_redirect }
      it { expect(project.slack_channels.count).to eq 1 }
    end
  end

  describe "#testing" do
    subject { post "/projects/#{project.id}/slack_channels/#{slack_channel.id}/testing" }

    context "success" do
      before { subject }

      it { expect(response).to be_redirect }
      it "follow redirect" do
        follow_redirect!
        expect(response).to be_success
        expect(response.body).to match("send")
      end
    end

    context "fail" do
      before { slack_channel.update_attribute :room, "" }
      before { subject }

      it { expect(response).to be_redirect }
      it "follow redirect" do
        follow_redirect!
        expect(response).to be_success
        expect(response.body).to match("fail")
      end
    end
  end
end
