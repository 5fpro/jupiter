form = $("<%= @dom_selector %>")
form.html('<%= j(render(partial: "remote_new")) %>')
form.find("[data-close-form]").on 'click', ->
  form.html('')
  false
