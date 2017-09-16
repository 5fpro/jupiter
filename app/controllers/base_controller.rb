class BaseController < ApplicationController
  before_action { set_meta }
  include CrudConcern

  def index
    set_meta(title: 'Jupiter@5FPRO')
  end
end
