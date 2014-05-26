module ApplicationHelper
  include Patches::WillPaginate
  extend ActiveSupport::Concern
  
  included do 
    @@view_content_with_procs = {}
  end
  
  def content_in(name, *arg, &block)
    if block_given?
      @@view_content_with_procs[name] = block
    else
      @@view_content_with_procs[name] = arg
    end
  end
  
  def content_from(name, *arg)
    if @@view_content_with_procs[name].kind_of?(Proc)
      content = @@view_content_with_procs[name].call(*arg)
      if content.kind_of?(Array)
        content.collect { |f| yield f }
      else
        content
      end
    else
      @@view_content_with_procs[name]#.join if @@view_content_with_procs[name]
    end
  end
  
  def view_id_name(id_name = nil)
    full_controller_name = controller_path.gsub(/\//, "_")
    id = id_name || "#{full_controller_name}_#{action_name}"
    if block_given?
      content_tag(:div, {:id => id} ) {yield}
    else
      id
    end
  end
  
  def default_view_id_name
    "main_block_top_row_4"
  end
  
  def add_css(obj, style_table)
    result = obj
    return result if obj.blank?
    style_table.each do |style|
      if result =~ style[0]
        style[1].each do |key, value|
          if result =~ /(?<=#{key.to_s}\=\")([.^>]*?)(?=\")/
            result = result.sub(/(?<=#{key.to_s}\=\")([.^\]*?)(?=\")/) { |match| "#{match} #{value}"}.html_safe
          else
            result = result.split(" ").insert(1, " #{key.to_s}='#{value}' ").join(" ").html_safe
          end
        end  
      end
    end
    result
  end
    

end
