require_relative '../../../shared_components/base_page'

class ConsentModal < BasePage

  EMAIL_RADIO_BTN = { css: '#email_address-label' }
  EMAIL_INPUT_FIELD = { css: '#email-address' }
  EMAIL_SUBMIT_BTN = { css: '#consent-submit-email-btn' }

  ON_SCREEN_CONSENT_RADIO_BTN = { css: '#on_screen-label' }
  ON_SCREEN_CONSENT_GO_TO_FORM = { css: '#go-to-form-btn' }
  LOADING_SPINNER = { css: '.overlay-spinner__text'}
  CONSENT_IFRAME = { css: '#consent-app-frame-iframe' }
  SIGNATURE_BOX = { css: '#signature-pad' }
  ACCEPT_BTN = { css: "#accept" }

  PHONE_NUMBER_RADIO_BTN = { css: '#phone_number-label' }
  PHONE_NUMBER_INPUT_FIELD = { css: '#phone-number' }
  PHONE_NUMBER_SUBMIT_BTN = { css: '#consent-submit-phone-btn' }
  VALID_PHONE_NUMBER = '2129999999' 

  def add_on_screen_consent 
    click(ON_SCREEN_CONSENT_RADIO_BTN)
    click(ON_SCREEN_CONSENT_GO_TO_FORM)
    is_not_displayed?(LOADING_SPINNER)

    scroll_down_consent(CONSENT_IFRAME)

    switch_to(CONSENT_IFRAME)
  
    driver.action.click_and_hold(find(SIGNATURE_BOX)).perform
    driver.action.move_by(50,50).perform
    driver.action.click(find(SIGNATURE_BOX)).perform

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
    replace_text(phone_number, PHONE_NUMBER_INPUT_FIELD)
    click(PHONE_NUMBER_SUBMIT_BTN)
  end

  def scroll_down_consent(selector)
    consent_box = find(selector)
    consent_box.send_keys :page_down
    consent_box.send_keys :page_down
    consent_box.send_keys :page_down
    consent_box.send_keys :page_down
    sleep(1)
  end 

end
