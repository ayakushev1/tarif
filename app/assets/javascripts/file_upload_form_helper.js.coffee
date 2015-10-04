#$(document).on "ajax:success", "*", (e, data, status, xhr) ->
#  row_url = $(this).attr("action_name")

#  $.ajax
#    url: row_url, 
#    async: false,
#    data: filtr,
#    dataType: "script",
#    headers: referer: row_url
#    success: (data, textStatus, jqXHR) ->
 