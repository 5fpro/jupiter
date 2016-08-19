
<% if @error_messages %>

$("<%= @dom_selector %>").append('<div class="error-messages"><%= j(simple_format(@error_messages)) %></div>')

<% else %>

dom = $(".project#project-<%= @project.id %>")
if dom.length > 0
  dom.html('<%= j(render(partial: "projects/project", object: @project, locals: { my_records: current_user.records })) %>')

dom = $(".new-record#todo-<%= @record.todo_id %>")
if dom.length > 0
  dom.html('')
  `
  <%=raw render(partial: "todos/not_done_todos", object: current_user.todos.sorted.not_done) %>
  <%=raw render(partial: "todos/processing_todos", object: current_user.todos.sorted.processing) %>
  <%=raw render(partial: "todos/done_todos", object: current_user.todos.sorted.today_done) %>
  `
<% end %>
