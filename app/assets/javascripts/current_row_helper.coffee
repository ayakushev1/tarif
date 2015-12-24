set_table_current_row = (row, e, async_mode = true) ->
  row_id_name = $(row).attr("current_id_name")
  row_url = $(row).attr("action_name")
  
  filtr = {}
  filtr["current_id"] = {}
  filtr["current_id"][row_id_name] = $(row).attr("value")

  $.ajax
    url: row_url, 
    async: async_mode,
    data: filtr,
    dataType: "script",
    headers: referer: row_url,
    success: (data, textStatus, jqXHR) ->

run_remote_link = (link, e) ->
  link_url = $(link).attr("href")

  $.ajax
    url: link_url, 
    async: true,
    data: $(link).data(),
    dataType: "script",
    headers: referer: link_url,

$(document).on 'click', "tr[id*=row]:not(.active), .panel[id*=row]:not(.active)", (e) ->
  if !(/^\//.test($(e.target).attr("href")))
    set_table_current_row(this, e)

$(document).on 'click', "a", (e) ->
  row_elements = $(this).parents("tr[id*=row], .panel[id*=row]")
  if row_elements.length > 0
    if !$(row_elements[0]).hasClass("active")
      set_table_current_row(row_elements[0], e, false)
    if $(this).attr("my_remote") == "true"
      e.preventDefault()
      run_remote_link(this, e) 
  