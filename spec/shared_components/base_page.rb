class BasePage
  SPINNER = { css: '.spinner' }

  attr_reader :driver

  def initialize(driver)
    @driver = driver
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

  def click_element_from_list_by_text(selector, text)
    list = find_elements(selector)
    found = false
    list.each do |element|
      if element.text == text
        element.click
        found = true
        break
      end
    end
    if (!found)
      raise StandardError.new "E2E ERROR: Option '#{text}' was not found in list of Selector #{selector}"
    end
  end

  def click_via_js(selector)
    element = find(selector)
    driver.execute_script('arguments[0].click();', element)
  end

  def click_within(context, selector)
    find_within(context, selector).click
  end

  def delete_all_char(selector)
    element = find(selector)
    #for input value fields and text fields
    string = element.text != '' ? element.text : element.attribute('value')
    string.split('').each do
      find(selector).send_keys :backspace
    end
  end

  def delete_char(selector)
    find(selector).send_keys :backspace
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

  def find_elements(selector)
    wait_for { driver.find_elements(selector) }
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
    driver.get ENV['web_url'] + path
  end

  def get_title
    wait_for { driver.title }
  end

  def get_uniteus_api_token
    JSON.parse(URI.decode("#{driver.manage.cookie_named("uniteusApiToken")[:value]}"))["access_token"]
  end

  def get_uniteus_group
    driver.execute_script('return window.sessionStorage.getItem("uniteusApiCurrentGroup");')
  end

  def get_uniteus_network
    driver.execute_script('return window.sessionStorage.getItem("uniteusApiCurrentNetwork");')
  end

  def get_uniteus_first_service_type_id
    networks = JSON.parse(driver.execute_script('return window.sessionStorage.getItem("uniteusApiCurrentUser");'))['networks']
    user_network = networks.find { |network| network['id'] == get_uniteus_network }
    user_network['service_types'][0]['children'][0]['id']
  end

  def get_uniteus_service_type_id_by_name(service_type)
    networks = JSON.parse(driver.execute_script('return window.sessionStorage.getItem("uniteusApiCurrentUser");'))['networks']
    user_network = networks.find { |network| network['id'] == get_uniteus_network }

    user_network['service_types'].each do |service|
      found = service['children'].find { |child| child['name'] == service_type }
      if found
        return found['id']
      end
    end
  end

  def hover_over(selector)
    driver.action.move_to(find(selector)).perform
  end

  def is_displayed?(selector)
    begin
      find(selector).displayed? ? true : print("E2E ERROR: Selector #{selector} was not present")
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

  def is_not_displayed?(selector, timeout = 10)
    begin
      wait_for(seconds = timeout) { !driver.find_element(selector).displayed? }
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

  # Similar to is_displayed? but without the time wrapper, and therefore returns
  # without waiting the 30 secs.
  # This is to be used when we know in advance that an element will be present or not.
  # For assertions we should still use is_displayed?
  def is_present?(selector)
    begin
      driver.find_element(selector)
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      false
    else
      true
    end
  end

  def is_selected?(selector)
    find(selector).selected?
  end

  # because all of our users and clients are U.S.-based,
  # phone numbers are formatted accordingly
  def number_to_phone_format(number)
    string = number.to_s
    area_code = string.slice(0, 3)
    exchange = string.slice(3, 3)
    line_number = string.slice(6, 4)
    return "(#{area_code}) #{exchange}-#{line_number}"
  end

  # for debugging race conditions and element visibility
  def print_page_source()
    puts("UUQA DEBUG Page Source is #{driver.page_source}")
  end

  def refresh
    driver.navigate().refresh()
  end

  def replace_text(text, selector)
    find(selector).send_keys [:control, 'a'], text
  end

  def scroll_to(selector)
    element = find(selector)
    driver.execute_script('arguments[0].scrollIntoView(true);', element)
  end

  # Some text boxes glide into the page, making local development difficult
  # For now its an explicit wait, but we can change this to create a better solution
  def sleep_for(seconds = 1)
    sleep(seconds)
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

  # explicit-wait wrapper for find_element methods to avoid flakiness caused by timing,
  # e.g., wait on find_element before interacting with it or asserting its visibility
  def wait_for(seconds = 30)
    Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
  end

  def wait_for_notification_to_disappear(notification = { css: '#notifications .notification' })
    wait_for() { find_elements(notification).length < 1 }
  end

  def wait_for_spinner(spinner = { css: '.spinner-container' })
    wait_for() { find_elements(spinner).length < 1 }
  end
end
