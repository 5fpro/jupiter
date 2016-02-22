dom = $('.js-todos-not-done')
<% if @not_done_todos %>
if dom.length > 0
  html = '<%= j(render(partial: "list", object: @not_done_todos)) %>'
  dom.html(html)
<% elsif @error_messages %>
target = $('.js-clone-todo-<%= @todo.id %>')
if target.length
  target.append('<div class="error-messages"><%= j(render_html(@error_messages.join("\n"))) %></div>')
<% end %>
