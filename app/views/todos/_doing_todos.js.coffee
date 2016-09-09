<% if doing_todos %>
dom = $('.js-todos-processing')
if dom.length > 0
  html = '<%= j(render(partial: "todos/list", object: doing_todos, locals: { processing: true })) %>'
  dom.html(html)
<% end %>
