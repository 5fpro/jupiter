module ContextMaker
  def record_created!(user, project)
    @record = RecordCreateContext.new(user, project).perform(attributes_for(:record))
  end
end
