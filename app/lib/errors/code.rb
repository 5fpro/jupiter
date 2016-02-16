class Errors::Code
  STATUS = {
    error_code_not_defined: 400,
    omniauth_parse_email_fail: 400,
    omniauth_already_auth: 400,
    omniauth_email_registered: 400,
    user_is_not_exist: 404,
    me_is_not_in_project: 401,
    user_is_in_project: 400,
    user_is_not_in_project: 401,
    cant_invite_youself: 400,
    cant_remove_youself: 401,
    not_project_owner: 401,
    params_required: 401,
    data_not_found: 404,
    value_blank: 400,
    data_create_fail: 400,
    data_update_fail: 400
  }

  class << self
    def exists?(key)
      status(key).present?
    end

    def status(key)
      STATUS[key.to_sym]
    end

    def desc(key)
      I18n.t("errors.#{@key}")
    end
  end

end
