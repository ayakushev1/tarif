submit_form_with_turbolinks = (form, event) ->
  event.preventDefault() 
  Turbolinks.visit form.action + '?' + $(form).serialize()
   
$(document).on 'submit_', "form[turbolinks=true]", (event) ->
  submit_form_with_turbolinks(this, event)
 
