<% if not_done_todos %>
dom = $('.js-todos-not-done')
if dom.length > 0
  html = '<%= j(render(partial: "todos/list", object: not_done_todos, locals: { not_done: true })) %>'
  dom.html(html)
<% end %>
