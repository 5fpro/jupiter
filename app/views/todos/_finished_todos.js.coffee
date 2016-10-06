<% if finished_todos %>
dom = $('.js-todos-finished')
if dom.length > 0
  html = '<%= j(render(partial: "todos/list", object: finished_todos)) %>'
  dom.html(html)
<% end %>
