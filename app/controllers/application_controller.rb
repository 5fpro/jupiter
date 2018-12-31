class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery prepend: true, with: :exception
  include MetaTagHelper

  before_action :http_auth_for_staging

  def default_url_options
    { protocol: Setting.default_protocol }
  end

  private

  def http_auth_for_staging
    return unless Rails.env.staging?

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['STAGING_USERNAME'] && password == ENV['STAGING_PASSWORD']
    end
  end
end
