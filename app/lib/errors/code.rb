class Errors::Code
  STATUS = {
    error_code_not_defined: 400,
    omniauth_parse_email_fail: 400,
    omniauth_already_auth: 400,
    omniauth_email_registered: 400,
    user_already_in_project: 400,
    user_is_not_in_project: 401,
    cant_do_for_yourself: 401,
    not_project_owner: 401,
    params_required: 400,
    data_not_found: 404,
    value_blank: 400,
    validates_fail: 400,
    data_create_fail: 400,
    data_update_fail: 400,
    data_delete_fail: 400,
    project_have_todo: 400,
    project_have_record: 400
  }.freeze

  class << self
    def exists?(key)
      status(key).present?
    end

    def status(key)
      STATUS[key.to_sym]
    end

    def desc(key)
      I18n.t("errors.#{key}")
    end
  end

end
