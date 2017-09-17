class UserAuthContext < BaseContext
  # before_perform :already_auth?, if: :current_user?
  before_perform :email_uniqueness?, if: :current_user?
  before_perform :find_or_create_user, unless: :current_user?
  before_perform :bind_authorization_to_user, unless: :has_authorization?
  after_perform :update_user_omniauth_data
  after_perform :user_confirm!
  after_perform :update_github_full_access_token
  after_perform :update_github_data!
  after_perform :new_user_comming

  attr_reader :email, :authorization

  # params should be env["omniauth.auth"] in controller
  def initialize(params, current_user = nil)
    @params = params.to_h.with_indifferent_access
    @provider = @params[:provider]
    @user = current_user
    @authorization = nil
  end

  def perform
    @authorization = find_authorization
    @email = parse_email
    return false if error?
    run_callbacks :perform do
      if @authorization
        responds
      else
        false
      end
    end
  end

  private

  def responds
    { user: @user,
      authorization: @authorization }
  end

  def find_authorization
    Authorization.find_by(provider: Authorization.providers[@provider], uid: @params[:uid])
  end

  def has_authorization?
    @authorization
  end

  def parse_email
    email = params_to_user_attributes[:email]
    errors.add(:email, :not_found) unless email
    email
  end

  def already_auth?
    if @authorization
      errors.add(:authorization, :taken)
      throw :abort
    end
  end

  def email_uniqueness?
    query = User.where(email: @email).where('id != ?', @user.id)
    unless query.count == 0
      errors.add(:email, :taken)
      throw :abort
    end
  end

  def find_or_create_user
    @user = @authorization.try(:auth) || User.find_by(email: @email) || initialize_user
    if @user.new_record?
      @new_user_comming = true
      @user.save!
    end
  end

  def bind_authorization_to_user
    @authorization = @user.authorizations.new(uid: @params[:uid], provider: @provider, auth_data: @params)
    self.errors = @authorization.errors unless @authorization.save
  end

  def update_user_omniauth_data
    @authorization.update auth_data: @params.to_h.to_h
  end

  def user_confirm!
    @user.confirm if @user.confirmable? && !@user.confirmed?
  end

  def current_user?
    @user.present?
  end

  def initialize_user
    user = User.new(params_to_user_attributes)
    def user.password_required?
      false
    end
    user
  end

  def params_to_user_attributes
    case @provider.to_sym
    when :facebook, :google_oauth2, :github
      info = @params[:info] || {}
      { email: info[:email], name: info[:name] }
    end
  end

  def provider_name
    @provider.to_s.titleize
  end

  def update_github_data!
    if @provider.to_sym == :github
      @user.update(name: @authorization.auth_data['info']['name'],
                   github_id: @authorization.uid,
                   github_account: @authorization.auth_data['info']['nickname'],
                   github_avatar: @authorization.auth_data['info']['image'],
                   github_token: @authorization.auth_data['credentials']['token'])
    end
  end

  def update_github_full_access_token
    @user.full_access_token = @authorization.auth_data['credentials']['token'] if @provider.to_sym == :github
  end

  def new_user_comming
    return unless @new_user_comming
    SlackService.notify_admin("新使用者註冊! (##{@user.id})#{@user.name}<#{@user.email}>")
  end
end
