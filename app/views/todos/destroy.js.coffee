`
<%= raw render(partial: "pending_todos", object: @pending_todos) %>
<%= raw render(partial: "doing_todos", object: @doing_todos) %>
`
<% if @error_messages %>
  todo_dom = $('js-delete-todo-<%= @todo.id %>')
  todo_dom.append('<div class="error-messages"><%= j(render_html(@error_messages.join("\n"))) %></div>')
<% end %>
