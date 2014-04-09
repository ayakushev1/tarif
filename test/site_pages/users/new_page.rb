module SitePages
  module Users
    class NewPage < Page
      path '/users/new'
      locator 'div[id=users_new]'
      element :form, 'form[id=new_user_form]'
      element :name, 'input[id=user_form_name]'
      element :password, 'input[id=user_form_password]'
      element :password_confirmation, 'input[id=user_form_password_confirmation]'
      element :submit, 'input[name=commit][type=submit]'
      action :create_user, :submit, :click
      action :fill_in_name, :name, :set, 'new user from test'
      action :fill_in_password, :password, :set, 111
      action :fill_in__confirmation, :password_confirmation, :set, 111
      action :back, "div[id=users_new]>a[href='/users']", :click
    end
  end
end
