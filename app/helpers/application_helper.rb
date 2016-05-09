module ApplicationHelper
  def collection_for_record_types
    Record.record_types.keys.map do |key|
      [record_type_name(key), key.to_sym]
    end
  end

  def collection_for_users(project = nil)
    # TODO: team
    users = project ? project.users : User.all
    users.map { |user| [user.name, user.id] }
  end

  def collection_for_project_todos(project)
    project.todos.merge(current_user.todos).for_bind.map { |todo| ["#{todo.done? ? "[已完成] " : ""}#{todo.desc}", todo.id] }
  end

  def collection_for_user_projects(user)
    user.projects.map { |project| [project.name, project.id] }
  end

  def collection_for_slack_channel_events
    Notify::Event.collection
  end

  def render_slack_channel_events(slack_channel)
    render_html slack_channel.events.map { |e| Notify::Event.desc(e) }.join("\n")
  end

  def render_html(text)
    text = simple_format(text, {}, wrapper_tag: 'div')
    text = auto_link(text, html: { target: "_blank" }, sanitize: false)
    raw text
  end

  def render_sorting_buttons(instance, column: :sort)
    scope = instance.class.to_s.split("::").last.underscore
    html = [:first, :up, :down, :last, :remove].map do |action|
      if action == :remove && instance.try(column).nil?
        ""
      else
        link_to action.to_s.camelize, send("#{scope}_path", instance, "#{scope}[#{column}]" => action, redirect_to: url_for), method: :put, class: "btn btn-default btn-small"
      end
    end.join(" ")
    raw html
  end

  def render_todo_detail_note(todo)
    todo_record_message = todo.records.map { |record| record.note.split.last.to_s + " / " + "#{record.minutes} minutes" }
    render_html todo_record_message.join("\n")
  end
end
