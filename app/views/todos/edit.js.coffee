html = '<%= j(render partial: "edit", as: :todo, object: @todo) %>'
$('.js-edit-todo-<%= @todo.id %>').html(html)
