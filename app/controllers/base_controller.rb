class BaseController < ApplicationController
  include CrudConcern

  def index
    set_meta(title: "Jupiter@5FPRO")
  end
end
