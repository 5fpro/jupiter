<% if pending_todos %>
dom = $('.js-todos-pending')
if dom.length > 0
  html = '<%= j(render(partial: "todos/list", object: pending_todos)) %>'
  dom.html(html)
<% end %>
