#require 'capybara/rails'
require 'capybara/poltergeist'  
module HistoryGetter
  class Scrapper   
    include Capybara::DSL
    
    def initialize
#      Capybara.run_server = false
 
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {js_errors: false})
      end
 
      Capybara.default_driver = :poltergeist 
   end

    def self.get_history
#      Scrapper.new
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {:js_errors => false})
      end
 
      Capybara.default_driver = :poltergeist 

      browser = Capybara.current_session
      page = browser.visit("http://www.mts.ru")
      links = browser.all 'li a'
      login_link = links.find{|l| l['href']=="https://login.mts.ru/"}
      login_link.click if login_link
      
#      login_page_address ='https://login.mts.ru/amserver/UI/Login?IDToken1=9852227039&IDToken2=6L6bD5'
#      Capybara.visit(login_page_address)
      browser.current_url
    end
  end  
  
  #HistoryGetter::Scrapper.get_history
  
  def self.get_history_1
    operator_page_address = 'http://www.mts.ru'
    login_page_link = 'https://login.mts.ru/'
    login_page_address = 'https://login.mts.ru/amserver/UI/Login?IDToken1=9852227039&IDToken2=6L6bD5'
    params = '?IDToken1=9852227039&IDToken2=6L6bD5'
    details_address_0 = 'https://ihelper.mts.ru/selfcare/doc-detail-report.aspx'
    agent = Mechanize.new { |agent_1|
      agent_1.user_agent_alias = 'Mac Safari'
      agent_1.follow_meta_refresh = true
    }
    
    agent.get(login_page_address)
    page0 = agent.get(details_address_0)
    form_0 = page0.forms[0]#("aspnetForm")
    form_0.add_field!('ctl00$MainContent$drp$from','13.12.2015')
    form_0.add_field!('ctl00$MainContent$drp$to','13.01.2016')
    page1 = form_0.submit
#      param_1 = page0.forms[0].keys.map{|key| "#{key}=#{page0.forms[0][key]}"}
#      param_1 = (param_1 + ["__EVENTTARGET=ctl00$MainContent$btnFirstToSecond"]).join("&")
    
#      details_address_1 = details_address_0 + "#?" + param_1
#      page1 = agent.post(details_address_1)
    result = page1

  end
end
