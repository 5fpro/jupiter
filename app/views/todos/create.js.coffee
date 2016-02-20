dom = $('.js-todos-not-done')
form = $('.js-new-todo-form')
if form.length == 0
  form = $('.js-new-todo-form-<%= @todo.try(:project_id) %>')

if dom.length > 0
<% if @not_done_todos %>
  html = '<%= j(render(partial: "list", object: @not_done_todos)) %>'
  dom.html(html)
<% else %>
  html = ''
<% end %>

<% if @error_messages %>
form.append('<div class="error-messages"><%= j(render_html(@error_messages.join("\n"))) %></div>')
<% else %>
form.html('')
<% end %>
