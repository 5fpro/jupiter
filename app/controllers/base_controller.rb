class BaseController < ApplicationController
  include CrudConcern

  def index
    set_meta(title: "Myapp Admin")
  end
end
