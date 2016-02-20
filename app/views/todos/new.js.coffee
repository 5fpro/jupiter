html = '<%= j(render partial: "new") %>'
dom = $('.js-new-todo-form')
<% if params[:project_id] %>
dom = $('.js-new-todo-form-<%= params[:project_id] %>')
<% end %>
dom.html(html)
dom.find('textarea').focus()
dom.find("[data-close-form]").on 'click', ->
  dom.html('')
  false
