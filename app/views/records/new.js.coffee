form = $(".project#project-<%= @project.id %> .form-new-record")
form.html('<%= j(render(partial: "remote_new")) %>')
form.find("[data-close-form]").on 'click', ->
  $(@).parents('.form-new-record').html('')
