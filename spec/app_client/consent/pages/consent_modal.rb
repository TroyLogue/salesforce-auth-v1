require_relative '../../../shared_components/base_page'

class ConsentModal < BasePage

  EMAIL_RADIO_BTN = { css: '#email_address-label' }
  EMAIL_TEXT_FIELD = { css: '#email-address' }
  EMAIL_SUBMIT_BTN = { css: '#consent-submit-email-btn' }

  def request_consent_by_email(address)
    click(EMAIL_RADIO_BTN)
    click(EMAIL_TEXT_FIELD) 
    clear_then_enter(address, EMAIL_TEXT_FIELD)
    click(EMAIL_SUBMIT_BTN) 
  end

end
