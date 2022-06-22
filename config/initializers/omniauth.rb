require 'omniauth/rails_csrf_protection/token_verifier'
OmniAuth.config.request_validation_phase = ::OmniAuth::RailsCsrfProtection::TokenVerifier.new

Rails.application.config.middleware.use OmniAuth::Builder do
  Setting.omniauth.providers.each do |provider, data|
    data = data.deep_symbolize_keys
    provider provider, data[:token], data[:secret], data[:options] || {}
  end
end

OmniAuth.config.path_prefix = "/authorizations"
