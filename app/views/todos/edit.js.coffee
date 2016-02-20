html = '<%= j(render partial: "edit", as: :todo, object: @todo) %>'
dom = $('.js-edit-todo-<%= @todo.id %>')
dom.html(html)
dom.find('[data-close-form]').on 'click', ->
  dom.html('<%= j(render_html(@todo.desc)) %>')
