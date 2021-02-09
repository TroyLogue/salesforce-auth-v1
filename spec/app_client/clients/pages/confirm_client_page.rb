require_relative '../../../shared_components/base_page'

class ConfirmClient < BasePage
  CONFIRMATION_CONTAINER = { css: '.contact-confirmation' }.freeze
  CONFIRMATION_CONTAINER_REFERRAL = { css: '.new-referrals-confirmation' }.freeze
  CONTACT_LIST = { css: '.contact-card' }.freeze
  CONTACT_BUTTON = { css: '.ui-button.contact-card__confirmation' }.freeze
  CONTACT_NAMES = { css: '.ui-base-card-header__title' }.freeze
  CONTACT_DOB = { css: '.ui-base-card-body dl:nth-child(1)' }.freeze
  CONTACT_PHONE = { css: '.ui-base-card-body dl:nth-child(2)' }.freeze
  CONTACT_ADDRESS = { css: '.ui-base-card-body dl:nth-child(3)' }.freeze
  CREATE_NEW_CLIENT_BTN = { css: '#create-new-client' }.freeze

  def page_displayed?
    is_displayed?(CONFIRMATION_CONTAINER) &&
    is_displayed?(CONTACT_LIST)
  end

  def referral_page_displayed?
    is_displayed?(CONFIRMATION_CONTAINER_REFERRAL) &&
    is_displayed?(CONTACT_LIST)
  end

  def clients_returned
    find_elements(CONTACT_LIST).length
  end

  def list_of_client_names
    find_elements(CONTACT_NAMES).collect(&:text)
  end

  # Follows 0 indexing
  def select_nth_client(index:)
    clients = find_elements(CONTACT_LIST)
    raise Selenium::WebDriver::Error::NoSuchElementError, "#{CONTACT_LIST}: no elements found" if clients.empty?

    clients[index].find_element(CONTACT_BUTTON).click
  end

  def select_client_with_dob(dob:)
    clients = find_elements(CONTACT_DOB)
    found = clients.each_with_index.map { |element, i| element.text.contains(dob) ? i : nil }.compact
    raise Selenium::WebDriver::Error::NoSuchElementError, "#{CONTACT_DOB} with value #{dob} not found" if found.empty?

    select_nth_client(index: found[0])
  end

  def select_client_with_phone(phone:)
    clients = find_elements(CONTACT_PHONE)
    found = clients.each_with_index.select { |element, i| element.text.contains(phone) ? i : nil }.compact
    raise Selenium::WebDriver::Error::NoSuchElementError, "#{CONTACT_PHONE} with value #{phone} not found" if found.empty?

    select_nth_client(index: found[0])
  end

  def select_client_with_address(address:)
    clients = find_elements(CONTACT_ADDRESS)
    found = clients.each_with_index.select { |element, i| element.text.contains(address) ? i : nil }.compact
    raise Selenium::WebDriver::Error::NoSuchElementError, "#{CONTACT_ADDRESS} with value #{address} not found" if found.empty?

    select_nth_client(index: found[0])
  end

  def click_create_new_client
    click(CREATE_NEW_CLIENT_BTN)
  end
end
