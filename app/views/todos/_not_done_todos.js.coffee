<% if not_done_todos %>
dom = $('.js-todos-not-done')
if dom.length > 0
  html = '<%= j(render(partial: "list", object: not_done_todos)) %>'
  dom.html(html)
<% end %>
