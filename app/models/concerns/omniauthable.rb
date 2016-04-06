module Omniauthable
  extend ActiveSupport::Concern

  module ClassMethods
    def omniauthable
      has_many :authorizations, dependent: :destroy, as: :auth
    end
  end

  def confirmable?
    respond_to?(:confirmed?)
  end

  protected

  def password_required?
    authorizations.!empty? ? false : true
  end
end
