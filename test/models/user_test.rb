require 'test_helper'

describe User do

    it 'should not save user without name' do
      @user = User.new(:password => '111', :password_confirmation => '111')
      @user.save.must_be :==, false 
    end
    
    it 'should not save with name but without password and/or password confirmation' do
      @user = User.new(:name => "Fred")
      assert !@user.save
    end
    
    it 'should save with name password and password confirmation' do
      @user = User.new(:name => "Fred", :password => '111', :password_confirmation => '111')
      assert @user.save
    end
    
  
end
