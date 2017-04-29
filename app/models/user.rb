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

class User < ActiveRecord::Base
  include Redis::Objects
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  store_accessor :data, :github_account, :github_id, :github_token, :github_avatar

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :async

  value :full_access_token, expiration: 6.hours

  mount_uploader :avatar, AvatarUploader

  omniauthable

  has_many :project_users
  has_many :projects, -> { order('project_users.sort') }, through: :project_users
  has_many :owned_projects, foreign_key: :owner_id, class_name: "Project"
  has_many :records
  has_many :comments
  has_many :todos

  def avatar_url
    return avatar.url if avatar?
    return github_avatar if github_avatar.present?
    nil
  end

  # overwrite devise method
  def send_on_create_confirmation_instructions
    # send_devise_notification(:confirmation_instructions)
  end
end
