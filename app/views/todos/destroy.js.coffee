`
<%= raw render(partial: "not_done_todos", object: @not_done_todos) %>
<%= raw render(partial: "processing_todos", object: @processing_todos) %>
`
<% if @error_messages %>
  todo_dom = $('js-delete-todo-<%= @todo.id %>')
  todo_dom.append('<div class="error-messages"><%= j(render_html(@error_messages.join("\n"))) %></div>')
<% end %>
