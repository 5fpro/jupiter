
#= require jquery-ui/datepicker
#= require jquery-ui/slider
#= require jquery.timepicker

$(document).ready ->
  $("#datetimepicker .form-group input").datetimepicker( { dateFormat: 'yy-mm-dd' } )
return
