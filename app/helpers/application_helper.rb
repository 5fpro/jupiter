module ApplicationHelper
  def collection_for_record_types
    Record.record_types.keys.map do |key|
      [record_type_name(key), key.to_sym]
    end
  end

  def collection_for_project_users(project)
    project.users.map { |user| [user.name, user.id] }
  end

  def collection_for_user_projects(user)
    user.projects.map { |project| [project.name, project.id] }
  end

  def collection_for_slack_channel_events
    Notify::Event.collection
  end

  def render_html(text)
    text = simple_format(text, {}, wrapper_tag: 'div')
    text = auto_link(text, html: { target: "_blank" }, sanitize: false)
    raw text
  end
end
