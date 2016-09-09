
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
  <%=raw render(partial: "todos/pending_todos", object: current_user.todos.sorted.pending) %>
  <%=raw render(partial: "todos/doing_todos", object: current_user.todos.sorted.doing) %>
  <%=raw render(partial: "todos/finished_todos", object: current_user.todos.sorted.today_done) %>
  `
<% end %>
