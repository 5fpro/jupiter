<% if done_todos %>
dom = $('.js-todos-done')
if dom.length > 0
  html = '<%= j(render(partial: "todos/list", object: done_todos)) %>'
  dom.html(html)
<% end %>
