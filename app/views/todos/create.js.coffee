`
<%= raw render(partial: "pending_todos", object: @pending_todos) %>
`

form = $('.js-new-todo-form')
if form.length == 0
  form = $('.js-new-todo-form-<%= @todo.try(:project_id) %>')
<% if @error_messages %>
form.append('<div class="error-messages"><%= j(render_html(@error_messages.join("\n"))) %></div>')
<% else %>
form.html('')
<% end %>
