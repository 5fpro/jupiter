module ApplicationHelper
  def collection_for_record_types
    Record.record_types.keys.map do |key|
      [record_type_name(key), key.to_sym]
    end
  end

  def collection_for_project_users(project)
    project.users.map { |user| [user.name, user.id] }
  end
end
