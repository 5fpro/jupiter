form = $('.js-edit-todo-<%= @todo.id %>')
dom = $('.js-update-todo-<%= @todo.id %>')
if dom.length > 0
<% if @error_messages %>
  dom.append('<div class="error-messages"><%= j(render_html(@error_messages.join("\n"))) %></div>')
<% else %>
  form.html('<%= j(render_html(@todo.desc)) %>')
  `
  <%= raw render(partial: "not_done_todos", object: @not_done_todos) %>
  `
<% end %>
