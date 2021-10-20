# frozen_string_literal: true

require_relative '../../lib/state_name_abbr'

class BasePage
  SPINNER = { css: '.spinner' }.freeze

  attr_reader :driver

  def initialize(driver)
    @driver = driver
  end

  def add_cookie(**params)
    driver.manage.add_cookie(name: params[:name], value: params[:value], domain: params[:domain])
  end

  def attribute(selector, attribute)
    find(selector).attribute(attribute)
  end

  def authenticate_and_navigate_to(token:, path: '')
    get(path)
    add_cookie(
      name: token[:name],
      value: token[:value],
      domain: ".#{ENV['WEB_URL'].partition('.').last.partition('/').first}"
    )
    get(path)
  end

  # similar to is_present? but checks for displayed
  # useful when an element may appear sometimes and sometimes may be hidden
  # is designed to be used when a page is loaded; note the short wait
  def check_displayed?(selector)
    wait_for(0.5) { driver.find_element(selector).displayed? }
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    false
  rescue Selenium::WebDriver::Error::TimeOutError
    false
  end

  # may return true, false, or nil
  def checkbox_value(element)
    checkbox = find(element)
    checkbox.attribute('checked')
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

  def click_element_by_text(selector, text)
    element = find_element_by_text(selector, text)
    element.click
  end

  def click_element_from_list_by_text(selector, text)
    list = find_elements(selector)
    found = false
    list.each do |element|
      next unless element.text == text

      element.click
      found = true
      break
    end
    raise StandardError, "E2E ERROR: Option '#{text}' was not found in list of Selector #{selector}" unless found
  end

  # Modification to above method for not strictly matching text
  def click_element_from_list_including_text(selector, text)
    list = find_elements(selector)
    found = false
    list.each do |element|
      next unless element.text.include?(text)

      element.click
      found = true
      break
    end
    raise StandardError, "E2E ERROR: Option '#{text}' was not found in list of Selector #{selector}" unless found
  end

  def click_parent(child_element)
    parent = child_element.find_element({xpath: "./.." })
    parent.click
  end

  def click_random(selector)
    random_option = find_elements(selector).sample
    raise StandardError, "E2E ERROR: No elements of Selector '#{selector}' were found" unless random_option
    random_option.click
  end

  def click_via_js(selector)
    driver.execute_script('arguments[0].click();', find(selector))
  end

  def click_within(context, selector)
    find_within(context, selector).click
  end

  def count(selector)
    find_elements(selector).length
  end

  def current_url
    driver.current_url
  end

  def delete_all_char(selector)
    element = find(selector)
    # for input value fields and text fields
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

  def enter_and_return(text, selector)
    find(selector).send_keys text, :return
  end

  # debugging tip: to verify value set, run
  # driver.execute_script("return document.querySelector(`#{selector_id}`).value")
  def enter_via_js(text, selector_id)
    driver.execute_script("document.querySelector(`#{selector_id}`).setAttribute('value', `#{text}`)")
  end

  def enter_within(text, context, selector)
    find_within(context, selector).send_keys text
  end

  def find(selector)
    wait_for { driver.find_element(selector) }
  end

  # this will work for any iframe and returns title attribute value
  def iframe_title
    wait_for { driver.find_element(:css, "iframe").attribute("title") }
  end

  def find_elements(selector)
    wait_for { driver.find_elements(selector) }
  end

  # returns an element
  def find_element_by_text(selector, text)
    find_elements(selector).select { |e| e.text == text }.first
  end

  # returns an element
  def find_element_containing_text(selector, text)
    find_elements(selector).select { |e| e.text.include? text }.first
  end

  # returns a boolean
  def find_element_with_text(selector, text)
    find(selector).text.include?(text)
  end

  def find_within(context, selector)
    wait_for { driver.find_element(context).find_element(selector) }
  end

  def get(path)
    driver.get ENV['WEB_URL'] + path
  end

  def get_auth(path)
    driver.get ENV['AUTH_URL'] + path
  end

  def hover_over(selector)
    driver.action.move_to(find(selector)).perform
  end

  def is_checked?(selector)
    find(selector).selected?
  end

  def is_displayed?(selector, timeout = 30)
    wait_for(timeout) { driver.find_element(selector).displayed? } ? true : print("E2E ERROR: Selector #{selector} was not present")
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

  # to be used when waiting for an element to disappear
  # but still present in the DOM;
  # because this method uses an implicit wait, it is subject to flakiness;
  # if an element disappears and is not present in the DOM,
  # use is_not_present?
  def is_not_displayed?(selector, timeout = 10)
    wait_for(timeout) { !driver.find_element(selector).displayed? }
  rescue Selenium::WebDriver::Error::NoSuchElementError
    true
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    true
  rescue Selenium::WebDriver::Error::TimeOutError
    # this will time out both when the element exists and does not exist - so we need to check again after the waiting period
    displayed = check_displayed?(selector)
    print "E2E ERROR: Selector #{selector} was present" if displayed
    !displayed
  else
    # this execute anytime no exception is thrown - so we need to check if the element is displayed or not
    displayed = check_displayed?(selector)
    print "E2E ERROR: Selector #{selector} was present" if displayed
    !displayed
  end

  # Similar to is_displayed? but without the time wrapper, and therefore returns
  # without waiting the 30 secs.
  # This is to be used when we know in advance that an element will be present or not.
  # For assertions we should still use is_displayed?
  def is_present?(selector)
    driver.find_element(selector)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    false
  else
    true
  end

  # to be used when waiting for an element to disappear
  # and removed from the DOM;
  # if an element disappears but is still present in the DOM,
  # use is_not_displayed?
  def is_not_present?(selector, timeout = 10)
    wait_for(timeout) { driver.find_elements(selector).empty? }
  end

  def is_selected?(selector)
    find(selector).selected?
  end

  def new_tab_opened?
    driver.window_handles.first != driver.window_handles.last
  end

  # because all of our users and clients are U.S.-based,
  # phone numbers are formatted accordingly
  def number_to_phone_format(number)
    string = number.to_s
    area_code = string.slice(0, 3)
    exchange = string.slice(3, 3)
    line_number = string.slice(6, 4)
    "(#{area_code}) #{exchange}-#{line_number}"
  end

  # for debugging race conditions and element visibility
  def print_page_source
    puts("UUQA DEBUG Page Source is #{driver.page_source}")
  end

  def refresh
    driver.navigate.refresh
  end

  def replace_text(text, selector)
    find(selector).send_keys [:control, 'a'], text
  end

  def scroll_to(selector)
    element = find(selector)
    driver.execute_script('arguments[0].scrollIntoView(true);', element)
  end

  def scroll_to_element_and_click(element)
    driver.execute_script('arguments[0].scrollIntoView(false)', element)
    element.click
  end

  def scroll_to_bottom_of_page
    main_container = find({ css: 'main' })
    driver.execute_script('arguments[0].scrollTo(0, arguments[0].scrollHeight);', main_container)
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

  def switch_to_last_window
    driver.switch_to.window(driver.window_handles.last)
  end

  def text(selector)
    find(selector).text
  end

  def text_include?(text, selector)
    find(selector).text.include?(text)
  end

  def title
    wait_for { driver.title }
  end

  def text_present?(selector)
    find(selector)
    wait_for(1) { !driver.find_element(selector).text.nil? }
  rescue Selenium::WebDriver::Error::TimeOutError
    print 'E2E ERROR: TimeOutError: text was nil'
    false
  end

  def value(selector)
    find(selector).attribute('value')
  end

  # explicit-wait wrapper for find_element methods to avoid flakiness caused by timing,
  # e.g., wait on find_element before interacting with it or asserting its visibility
  def wait_for(seconds = 30)
    Selenium::WebDriver::Wait.new(timeout: seconds).until { yield }
  end

  def wait_for_element_to_disappear(selector)
    wait_for { find_elements(selector).length < 1 }
  end

  def wait_for_notification_to_disappear(notification = { css: '#notifications .notification' })
    wait_for { find_elements(notification).length < 1 }
  end

  def wait_for_spinner(spinner = { css: '.spinner-container' })
    wait_for { find_elements(spinner).length < 1 }
  end

  def wait_for_download_spinner(spinner = { css: '.spin-icon.spinning' })
    wait_for { find_elements(spinner).length < 1 }
  end
end
