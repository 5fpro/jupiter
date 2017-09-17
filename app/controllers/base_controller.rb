class BaseController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :format_js?
  before_action :set_meta
  include CrudConcern

  def index; end

  private

  def format_js?
    request.format.to_s == 'js'
  end
end
