dom = $(".project#project-<%= @project.id %>")

<% if @error_messages %>

dom.find('.form-new-record').append('<div class="error-messages"><%= j(simple_format(@error_messages)) %></div>')

<% else %>

dom.html('<%= j(render(partial: "projects/project", object: @project, locals: { records: current_user.records })) %>')

<% end %>
