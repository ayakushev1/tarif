require 'test_with_capibara_helper'

describe UsersController do
  describe 'new action' do
    it 'must verify description of new view' do
      SitePages::Users::NewPage.new.verify.must_be :==, true
    end
    
    it 'must create new user if input correct' do
      js do
        assert_difference "User.count", 1 do
          user_name = User.last ? User.last.name + "_1" : 'user_222'
          SitePages::Users::NewPage.new.tap do |u|
            visit u.path
            u.name.set(user_name)
            u.password.set('111')
            u.password_confirmation.set('111')
            u.create_user
          end
          assert_selector SitePages::Users::NewPage.new.locator 
          assert_selector SitePages::Users::ShowPage.new.locator 
        end
      end

    end
      
    it 'should not create new user with the same name' do
#      js do
        assert_difference "User.count", 0 do
          user_name = User.last ? User.last.name + "_1" : 'user_222'
          SitePages::Users::NewPage.new.tap do |u|
            visit u.path
            u.name.set(user_name)
            u.password.set('111')
            u.password_confirmation.set('1111')
            u.create_user
          end
          assert_no_selector SitePages::Users::ShowPage.new.locator 
        end
#      end
    end
    
    it 'must go back if press on link Back' do
      js do
        SitePages::Users::NewPage.new.tap do |u|
          visit u.path
          u.back
          assert_no_selector u.locator
        end
      end
    end
    
    it 'must send ajax after updating form fields' do
      js do
        SitePages::Users::NewPage.new.tap do |u|
          visit '/users/new?user_form[name]=user11'
          u.name.value.must_be :==, 'user11'
        end
      end
    end
  end
  
  describe 'index action' do
    it 'must choose correct user to edit' do
      visit users_path
      page.first("a[href*='/edit']").click
      assert_selector('div[id=users_edit]')
    end
  end
end
