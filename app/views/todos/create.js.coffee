dom = $('.js-todos-not-done')
if dom.length > 0
<% if @not_done_todos %>
  html = '<%= j(render(partial: "list", object: @not_done_todos)) %>'
  dom.html(html)
<% else %>
  dom.append('<div class="error-messages"><%= j(render_html(@error_messages.join("\n"))) %></div>')
<% end %>
