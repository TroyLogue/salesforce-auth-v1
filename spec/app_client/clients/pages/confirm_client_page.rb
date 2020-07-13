require_relative '../../../shared_components/base_page'

class ConfirmClient < BasePage
  CONFIRMATION_CONTAINER = { css: '.contact-confirmation' }
  CONTACT_LIST = { css: '.contact-card' }
  CONTACT_BUTTON = { css: '.ui-button.contact-card__confirmation' }

  def page_displayed?
    is_displayed?(CONFIRMATION_CONTAINER) &&
    is_displayed?(CONTACT_LIST)
  end

  def clients_returned
    find_elements(CONTACT_LIST).length
  end

  def select_nth_client(index:)
    clients = find_elements(CONTACT_LIST)
    click_within(clients[index], CONTACT_BUTTON)
  end
end
