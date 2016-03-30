module SitePages
  module Users
    class ShowPage < Page
      path '/users/:id'
      locator 'div[id=users_show]'
      element :notice, 'p[id=notice]'
      action :edit, 'div[id=users_show]>a[href^=/users][href$=/edit]', :click_link
      action :back, 'div[id=users_show]>a[href=/users]', :click_link
    end
  end
end
