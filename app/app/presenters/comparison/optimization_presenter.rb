module Comparison::OptimizationPresenter
  def show_as_popover(title, content)
    html = {
      :tabindex => "0", 
      :role => "button", 
      :'data-toggle' => "popover", 
      :'data-trigger' => "focus", 
      :'data-placement' => "top",
      :title => "Потребление мобильной связи", 
      :'data-content' => content,
      :'data-html' => true,
      :class => "btn-primary"
    }
    
    content_tag(:div, html) do
      "#{title}".html_safe + content_tag(:span, " ") + content_tag(:span, "", {:class => "fa fa-info-circle fa-1x", :'aria-hidden' =>false})
    end
  end

end

