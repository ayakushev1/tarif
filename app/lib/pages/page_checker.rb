module PageChecker
  def equal_to_current_capybara_page?
    page and page.current_path and (page.all(self.locator).count == 1) ? true : false
  end
  
end
