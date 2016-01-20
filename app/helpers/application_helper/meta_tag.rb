module ApplicationHelper::MetaTag
  
  def default_meta_tags
    {
      title:       'Title',
#      description: 'Member login page.',
#      keywords:    'Site, Login, Members',
      separator:   "&mdash;".html_safe,
    }
  end  
end