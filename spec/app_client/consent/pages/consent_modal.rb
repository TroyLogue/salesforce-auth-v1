require_relative '../../../shared_components/base_page'

class ConsentModal < BasePage

  EMAIL_RADIO_BTN = { css: '#email_address-label' }
  EMAIL_INPUT_FIELD = { css: '#email-address' }
  EMAIL_SUBMIT_BTN = { css: '#consent-submit-email-btn' }

  ON_SCREEN_CONSENT_RADIO_BTN = { css: '#on_screen-label' }
  ON_SCREEN_CONSENT_GO_TO_FORM = { css: '#go-to-form-btn' }

  # to ask devs to add an id or name attr. to the iframe so we can switch to it
  # CONSENT_IFRAME_ID
  SIGNATURE_BOX = { css: '#signature-pad' }
  ACCEPT_BTN = { css: "span:contains('Accept')" }

  PHONE_NUMBER_RADIO_BTN = { css: '#phone_number-label' }
  PHONE_NUMBER_INPUT_FIELD = { css: '#phone-number' }
  PHONE_NUMBER_SUBMIT_BTN = { css: '#consent-submit-phone-btn' }
  VALID_PHONE_NUMBER = '2129999999' 

  def add_on_screen_consent 
    click(ON_SCREEN_CONSENT_RADIO_BTN)
    click(ON_SCREEN_CONSENT_GO_TO_FORM)
    # switch to iframe
    # switch_to(CONSENT_IFRAME_ID)
    click(SIGNATURE_BOX)
    click(ACCEPT_BTN)
  end

  def request_consent_by_email(address)
    click(EMAIL_RADIO_BTN)
    click(EMAIL_INPUT_FIELD) 
    clear_then_enter(address, EMAIL_INPUT_FIELD)
    click(EMAIL_SUBMIT_BTN) 
  end

  def request_consent_by_text(phone_number) 
    click(PHONE_NUMBER_RADIO_BTN)
    click(PHONE_NUMBER_INPUT_FIELD)
    clear_then_enter(phone_number, PHONE_NUMBER_INPUT_FIELD)
    click(PHONE_NUMBER_SUBMIT_BTN)
  end

end
