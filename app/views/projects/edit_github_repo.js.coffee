dom = $('.edit_project')
if dom.length > 0
  dom.html('')

dom = $("<%= @dom_selector %>")
if dom.length > 0
  dom.html('<%= j(render(partial: "projects/bind_github", locals: { repos: @repos })) %>')
