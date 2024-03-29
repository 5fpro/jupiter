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

FactoryBot.define do
  factory :user do
    name { '5Fpro' }
    sequence(:email) { |n| "user#{n}@5fpro.com" }
    password { '12341234' }
    confirmed_at { Time.now }
    github_avatar { 'https://example.com/xxx.png' }

    factory :admin_user do
      admin { true }
    end

    factory :unconfirmed_user do
      confirmed_at { nil }
    end

    factory :user_with_avatar do
      avatar { File.open(Rails.root.join('spec', 'fixtures', '5fpro.png')) }
    end
  end

  factory :user_for_create, class: 'User' do
    name { '5Fpro' }
    sequence(:email) { |n| "user#{n}@5fpro.com" }
    password { '12341234' }
    admin { '0' }
  end
end
