require 'test_with_capibara_helper'

LOCATOR_C = "div[id=users_new]"#:contains(\'New user\')"

class DummyPage < Page
  path '/users/new'
  locator LOCATOR_C
  element :name, 'input[id=user_form_name]'
  element :password, 'input[id=user_form_password]'
  element :password_confirmation, 'input[id=user_form_password_confirmation]'
  element :submit, 'input[name=commit][type=submit]'
  action :create, 'input[name=commit][type=submit]', :click
  action :fill_in_name, 'input[id=user_form_name]', :set, 'new user from test'
  action :fill_in_password, :password, :set, 111
  action :fill_in__confirmation, :password_confirmation, :set, 111
end

class DummyController < ApplicationController
end

describe DummyController do
  
  describe 'testing Page in controller test environment' do
    describe 'initialize method' do
      it 'must init @page with Capybara.current_session' do
        Page.new.page.must_be_instance_of Capybara::Session
      end
      
      it 'must init @elements and @actions as {}' do
        DummyPage.instance_variable_defined?(:@elements).must_be :==, true
        DummyPage.instance_variable_defined?(:@actions).must_be :==, true
      end              
    end

    describe 'class methods' do
      describe 'element method' do
        before do
          DummyPage.element :name, 'input[id=user_form_name]'          
        end
        
        it 'must define instance method' do
          DummyPage.new.must_respond_to :name
        end
        
        it 'must add element and its description to elements' do
          DummyPage.elements[:name].wont_be_nil
          DummyPage.elements[:name][:locator].wont_be_nil
        end
        
        it 'must return Capybara::Node::Element' do
          DummyPage.new.tap do |d|
            visit d.path
            d.name.must_be_kind_of Capybara::Node::Element
            d.name[:id].must_be :==, 'user_form_name'
          end
        end
      end
        
      describe 'action method' do
        before do
          DummyPage.action :create, 'input[type=submit]', :click          
        end
        
        it 'must define instance method' do
          DummyPage.new.must_respond_to :create
        end
        
        it 'must add action and its description to elements' do
          DummyPage.actions[:create].wont_be_nil
          DummyPage.actions[:create][:locator].wont_be_nil
          DummyPage.actions[:create][:capybara_action].wont_be_nil
          DummyPage.actions[:create].keys.include?(:capybara_action).must_be :==, true
        end
        
        it 'must do action' do
          DummyPage.new.tap do |d|
            visit d.path
            page.first('div')
            d.create
          end
        end

        it 'must recognise element name as locator' do
          DummyPage.action :create, :submit, :click
          DummyPage.new.tap do |d|
            visit d.path
            page.first('div')
            d.create
          end
        end

      end

      describe 'verify method' do
        it 'should not run on Page class' do
          Page.new.verify.must_be :==, false
        end
        
        it 'must check path, locator, all elements and actions and return their list ' do
          DummyPage.new.verify.must_be :==, true
        end

        it 'should not verify with wrong path' do
          Class.new(DummyPage) do |d_class|
            d_class.path '/users/new_1'
            d_class.locator DummyPage.new.locator
            d_class.new.verify.must_be :==, false
          end
        end

        it 'should not verify with wrong locator' do
          Class.new(DummyPage) do |d_class|
            d_class.path '/users/new'
            d_class.locator 'div'
            d_class.new.verify.must_be :==, false
          end
        end
      end        
      
      describe 'elements method' do
        it 'must return collection of all element as hash' do
          DummyPage.elements.tap do |e|
            e.wont_be_nil
            e.must_be_kind_of(Hash)
            e[:name].wont_be_nil          
            e[:name][:locator].wont_be_nil
          end          
        end
      end

      describe 'actions method' do
        it 'must return collection of all actions as hash' do
          DummyPage.actions.tap do |e|
            e.wont_be_nil
            e.must_be_kind_of(Hash)
            e[:create].wont_be_nil          
            e[:create][:locator].wont_be_nil          
            e[:create][:capybara_action].wont_be_nil
            e[:create].keys.include?(:options).must_be :==, true
  
            e[:fill_in_password].wont_be_nil          
            e[:fill_in_password][:locator].wont_be_nil          
            e[:fill_in_password][:capybara_action].wont_be_nil
            e[:fill_in_password][:options].wont_be_nil
          end
        end
      end
    end
        
    describe 'instance methods' do
      describe 'page instance method' do
        it 'must return the same Capybara.current_session as in running test' do
          Page.new.page.must_be_same_as page
        end      
      end
      
      describe 'path instance method' do
        it 'must return value set by Page.path' do
          DummyPage.new.path.must_be :==, '/users/new'
        end      
        
        it 'must accept variable and insert it instead of :id' do
          Class.new(DummyPage) do |d_class|
            d_class.path '/users/:id/show'
            d_class.new.path(1111).must_be :==, '/users/1111/show'
          end
        end
      end
      
      describe 'locator instance method' do
        it 'must return value set by Page.locator' do
          DummyPage.new.locator.must_be :==, LOCATOR_C
        end      
      end
      
      describe 'location instance method' do
        it 'must have location with page.all(@locator) if page have been visited, or nil' do
          Class.new(DummyPage).tap do |d_class|
            d_class.new.tap do |p|
              d_class.path DummyPage.new.path
              d_class.locator DummyPage.new.locator
              visit '/logout'
              p.location.must_be_nil 'location before page visit'
              visit p.path
              p.location.wont_be_nil 'location after page visit'
            end
          end
        end
        
        it 'must raise error locator is not uniq' do
          Class.new(DummyPage).tap do |d|
            d.path DummyPage.new.path
            d.locator 'wrong_locator'
            d_object = d.new
            visit d_object.path
            begin
              d_object.location
            rescue Capybara::ElementNotFound, Capybara::Ambiguous => e
              assert true, e.message
            else
              assert false            
            end
          end        
        end
      end
  
      describe 'equal_to_current_capybara_page? method' do 
        it 'must return true if current capybara page is matched by path and locator with Page path and locator' do
          DummyPage.new.tap do |d|
            visit d.path
            page.first('div')
            d.equal_to_current_capybara_page?.must_be :==, true
          end
        end
  
        it 'must return false if current capybara page path is not Page path' do
          DummyPage.new.tap do |d|
            visit '/users/0'
            page.first('div')
            d.equal_to_current_capybara_page?.must_be :==, false
          end
        end
  
        it 'must return false if current capybara page has not exactly one Page locator' do
          js do
            DummyPage.new.tap do |d|
              visit d.path
              page.first(LOCATOR_C)
              page.execute_script("$('div').html('ddddddddddddddddssssssssssssss')")
              d.equal_to_current_capybara_page?.must_be :==, false
            end
          end 
        end
      
      end            

      
    end
  
  end
end
