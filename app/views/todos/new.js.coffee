html = '<%= j(render partial: "new") %>'
dom = $('.js-new-todo-form')
dom.html(html)
<% if params[:project_id] %>
dom.find('textarea').focus()
<% end %>
dom.find("[data-close-form]").on 'click', ->
  dom.html('')
  false
