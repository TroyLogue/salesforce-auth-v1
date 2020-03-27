class BasePage
 
  attr_reader :driver 

  def initialize(driver)
    @driver = driver
  end

  # explicit-wait wrapper for find_element methods to avoid flakiness caused by timing, 
  # e.g., wait on find_element before interacting with it or asserting its visibility
  def wait_for(seconds = 30)
    Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
  end

  def clear(selector) 
    find(selector).clear
  end

  def clear_then_enter(text, selector)
    find(selector).clear
    find(selector).send_keys text
  end

  def clear_within(context, selector) 
    find_within(context, selector).clear
  end

  def click(selector) 
    find(selector).click
  end

  def click_via_js(selector)
    element = find(selector)
    driver.execute_script("arguments[0].click();", element)
  end

  def click_within(context, selector) 
    find_within(context, selector).click
  end

  def enter(text, selector)
    find(selector).send_keys text
  end

  # debugging tip: to verify value set, run 
  # driver.execute_script("return document.getElementById(`#{selector_id}`).value")
  def enter_via_js(text, selector_id)
    driver.execute_script("document.getElementById(`#{selector_id}`).setAttribute('value', `#{text}`)")
  end

  def enter_within(text, context, selector) 
    find_within(context, selector).send_keys text
  end

  def find(selector)
    wait_for { driver.find_element(selector) }
  end

  def find_element_with_text(selector, text)
    find(selector).text.include?(text)
  end

  def find_within(context, selector) 
    wait_for { driver.find_element(context).find_element(selector) }
  end

  def generate_timestamp
    timestamp = Time.now.strftime('%m%d%Y%H%M%S')
    return timestamp
  end

  def get(path)
    driver.get ENV['base_url'] + path
  end

  def get_title
    wait_for { driver.title }
  end

  def hover_over(selector)
    driver.action.move_to(find(selector)).perform
  end
  
  def is_displayed?(selector)
    begin
      find(selector).displayed?
    rescue Selenium::WebDriver::Error::NoSuchElementError
      print "E2E ERROR NoSuchElementError at #{selector}"
      false
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      print "E2E ERROR StaleElementReferenceError at #{selector}"
      false
    rescue Selenium::WebDriver::Error::TimeOutError
      print "E2E ERROR TimeOutError at #{selector}"
      false
    end
  end

  def is_not_displayed?(selector)
    begin 
      wait_for(seconds = 8) { !driver.find_element(selector).displayed? } 
    rescue Selenium::WebDriver::Error::NoSuchElementError
      return true
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      return true
    rescue Selenium::WebDriver::Error::TimeOutError
      return true
    else
      return false 
      print "E2E ERROR: Selector #{selector} was present"
    end
  end

  def refresh
    driver.navigate().refresh()
  end

  def replace_text(text, selector)
    find(selector).send_keys [:control, 'a'], text
  end

  def scroll_to(selector) 
    element = find(selector)
    driver.execute_script("arguments[0].scrollIntoView(true);", element);
  end

  def submit(selector) 
    find(selector).submit
  end

  def switch_to(frame) 
    iframe = find(frame)
    driver.switch_to.frame(iframe)
  end

  def text(selector) 
    find(selector).text
  end

  def text_include?(text, selector)
    find(selector).text.include?(text)
  end

end
