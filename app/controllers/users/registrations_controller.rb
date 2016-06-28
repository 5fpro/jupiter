class Users::RegistrationsController < Devise::RegistrationsController
  before_action :redirect_new_to_sign_in, only: [:new]

  protected

  def redirect_new_to_sign_in
    redirect_to new_user_session_path
  end

end
