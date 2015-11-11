module ApplicationHelper::DeviseSettings

  def after_sign_in_path_for(resource)
    root_path
  end
    
  private
    
end
