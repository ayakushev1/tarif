module ApplicationHelper
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
    id = id_name || "#{controller_name}_#{action_name}"
    if block_given?
      content_tag(:div, {:id => id} ) {yield}
    else
      id
    end
  end
  
  def add_css(obj, style_table)
    result = obj
    return result if obj.empty?
    style_table.each do |style|
      if obj =~ style[0]
        style[1].each do |key, value|
          if obj =~ /#{key.to_s}/
            result = obj.sub(/(?<=#{key.to_s}\=\")(.*?)(?=\")/) { |match| "#{match} #{value}"}.html_safe
          else
            result = obj.split(" ").insert(1, " #{key.to_s}='#{value}'").join(" ").html_safe
          end
        end  
      end
    end
    result
  end

end
