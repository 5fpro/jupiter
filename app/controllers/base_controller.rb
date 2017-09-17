class BaseController < ApplicationController
  before_action :set_meta
  include CrudConcern

  def index; end
end
