# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime
#  updated_at             :datetime
#  admin                  :boolean          default(FALSE)
#  avatar                 :string
#  data                   :hstore
#  todos_published        :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create :user }

  context 'FactoryGirl' do
    it { expect(user).not_to be_new_record }
    it { expect(FactoryGirl.create(:user_with_avatar).avatar.url).to be_present }
    it { expect(FactoryGirl.create(:unconfirmed_user).confirmed?).to eq false }
    it { expect(FactoryGirl.create(:admin_user).admin?).to eq true }
    it { attributes_for :user_for_create }
  end

  it 'devise async' do
    expect {
      FactoryGirl.create :unconfirmed_user
    }.not_to have_enqueued_job(Devise::Mailer)
  end
end
