module ApplicationHelper::DefaultRenderer
#  extend ActiveSupport::Concern
  def default_render(options = nil)    
#    raise(StandardError, [controller_name, action_name, params])
    
    respond_to do |format|
      format.js {render_js(view_context.default_view_id_name)}
      format.html
      format.json
    end
  end

  def render_js(id_of_page_to_substitute, template = action_name)
    view_context.tap do |v|
      js_string = v.content_tag(:div, render_to_string(template), {:id => v.view_id_name})
      js_string = "$('##{id_of_page_to_substitute}').html(\" #{v.escape_javascript js_string} \");"          
#      render action_name
      render :inline => js_string#, :layout => 'application'
    end
  end
  
end
