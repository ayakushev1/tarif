$(document).on 'change', "[type=checkbox]", ->
  if $.isEmptyObject($(this).attr('checked'))
    $(this).attr('checked', true)
  else
    $(this).attr('checked', false)
