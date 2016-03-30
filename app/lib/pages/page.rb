class Page
  include Capybara::DSL
  attr_reader :page
  
  def initialize
    self.extend PageChecker
    @page = Capybara.current_session
    @elements = {}
    @actions = {}
  end      
  
  class << self
    attr_reader :elements, :actions
    
    def path(path)
      @path = path =~ /^.*?_(path|url)$/ ? Rails.application.routes.url_helpers.send(path.to_sym) : path
    end
    
    def locator(locator = nil, &block)
      @locator = block_given? ? block.call : locator
    end
    
    def element(name, locator)
      add_element_to_elements(name, locator)
      define_method name.to_sym do
        page.find locator
      end
    end

    def action(name, locator, capybara_action, *options)
      add_action_to_actions(name, locator, capybara_action, *options)
      locator = elements[locator][:locator] if elements[locator] 
      define_method name.to_sym do
        case capybara_action.to_sym
        when :check, :choose, :click_button, :click_link, :click_link_or_button, :fill_in, :select, :uncheck, :unselect
          page.send(capybara_action, locator, options)
        when :checked?, :click, :disabled?, :hover, :inspect, :select_option, :selected?, :tag_name, :unselect_option, :value, :visible?  
          page.find(locator).send(capybara_action)
        when :set, :trigger
          page.find(locator).send(capybara_action, options[0])
        end
      end
    end
    
  end
  
  def path(insert_value = nil)
    self.class.instance_variable_get(:@path).gsub(/(\:id)/, (insert_value.to_s || ':id') )
  end
  
  def locator
    self.class.instance_variable_get(:@locator)
  end

  def location    
    @location = ( self.page.current_path == self.path and @location.blank? ) ? page.find(self.locator) : @location
  end 

  def verify
    begin 
      return false if self.class == Page
      page.visit self.path 
      return false unless self.equal_to_current_capybara_page?
      self.class.elements.each { |key, value| send(key)}
      true
    rescue =>e
      e.message
    end
  end

protected
  def self.add_element_to_elements(name, locator)
    @elements ||= {}
    @elements[name] = {}
    @elements[name][:locator] = locator
  end
  
  def self.add_action_to_actions(name, locator, capybara_action, *options)
    @actions ||= {}
    @actions[name] = {}
    @actions[name][:locator] = locator
    @actions[name][:capybara_action] = capybara_action
    @actions[name][:options] = options
  end

end
