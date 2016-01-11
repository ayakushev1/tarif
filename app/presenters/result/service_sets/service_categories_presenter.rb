module Result::ServiceSets::ServiceCategoriesPresenter
  def geo_presenter(category_group_item, array_of_geo_names = [])
    (array_of_geo_names - [""]).blank? ? category_group_item : show_as_popover(category_group_item, array_of_geo_names.join(", "))
  end
  
  def show_as_popover(title, content)
    html = {
      :tabindex => "0", 
      :role => "button", 
      :'data-toggle' => "popover", 
      :'data-trigger' => "focus", 
      :'data-placement' => "bottom",
      :title => title, 
      :'data-content' => content,
      :'data-html' => true
    }
    
    content_tag(:a, html) do
      "#{title} ".html_safe + content_tag(:span, "", {:class => "fa fa-info-circle fa-1x", :'aria-hidden' =>true})
    end
  end

end

