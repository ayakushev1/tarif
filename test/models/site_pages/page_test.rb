require 'test_with_capibara_helper'
describe Page do
  
  it 'class variables (e.g. @path) for Page subclasses must be different' do
    page_1 = Class.new(Page) { path 'path_1'}
    page_2 = Class.new(Page) { path 'path_2'}
    page_1.new.path.wont_be :==, page_2.new.path
  end

  describe "class methods" do
    it 'must have methods' do
      [:path, :locator, :element, :elements, :action, :actions].each {|method| Page.must_respond_to method}
    end
    
    describe "path method" do
      it 'must undestand ActionController *_path BUT not *_url functions' do
        Page.path('new_user_path').must_be :==, '/users/new'
        -> { Page.path('new_user_url') }.must_raise ArgumentError         
      end
    end
    
    end

    describe "locator method" do
      it 'must accept block' do
        Page.locator {true}
      end
    end
  
  end

  describe "instance methods" do
    it 'must have methods' do
      [:path, :locator, :page, :location, :equal_to_current_capybara_page?, :verify].each {|method| Page.new.must_respond_to method}
    end

    describe "path method" do
      it 'must return value set by set_path method' do
        Page.path(String.new("mock"))
        Page.new.path.must_be :==, 'mock'
      end      
  end  
end
