require_relative '../../../shared_components/base_page'

class ConsentModal < BasePage

  EMAIL_RADIO_BTN = { css: '#email_address-label' }
  EMAIL_INPUT_FIELD = { css: '#email-address' }
  EMAIL_SUBMIT_BTN = { css: '#consent-submit-email-btn' }

  DOCUMENT_UPLOAD_RADIO_BTN = { css: '#document-label' }
  DOCUMENT_UPLOAD_FILE_INPUT = { css: "#Consent > section > div > input[type=file]"} 
  CONSENT_FILE_PATH = "lib/files/fakeConsent.txt"
  DOCUMENT_SUBMIT_BTN = { css: '#audio-document-consent-btn' }

  ON_SCREEN_CONSENT_RADIO_BTN = { css: '#on_screen-label' }
  ON_SCREEN_CONSENT_GO_TO_FORM = { css: '#go-to-form-btn' }
  LOADING_SPINNER = { css: '.overlay-spinner__text'}
  CONSENT_IFRAME = { css: '#consent-app-frame-iframe' }
  SIGNATURE_BOX = { css: '#signature-canvas' }
  ACCEPT_BTN = { css: "#accept" }

  PHONE_NUMBER_RADIO_BTN = { css: '#phone_number-label' }
  PHONE_NUMBER_INPUT_FIELD = { css: '#phone-number' }
  PHONE_NUMBER_SUBMIT_BTN = { css: '#consent-submit-phone-btn' }
  VALID_PHONE_NUMBER = '2129999999' 

  def add_consent_by_document_upload
    click(DOCUMENT_UPLOAD_RADIO_BTN)
    filename = CONSENT_FILE_PATH
    file = File.join(Dir.pwd, filename)
    enter(file, DOCUMENT_UPLOAD_FILE_INPUT)  
    click(DOCUMENT_SUBMIT_BTN)
  end

  def add_on_screen_consent 
    click(ON_SCREEN_CONSENT_RADIO_BTN)
    click(ON_SCREEN_CONSENT_GO_TO_FORM)
    is_not_displayed?(LOADING_SPINNER)

    scroll_down_consent(CONSENT_IFRAME)

    driver.action.move_by(500, 500).perform
    driver.action.click_and_hold.perform
    driver.action.move_by(50, 0).perform
    driver.action.click.perform

    switch_to(CONSENT_IFRAME)
    click_via_js(ACCEPT_BTN)
  end

  def request_consent_by_email(address)
    click(EMAIL_RADIO_BTN)
    click(EMAIL_INPUT_FIELD) 
    clear_then_enter(address, EMAIL_INPUT_FIELD)
    click(EMAIL_SUBMIT_BTN) 
  end

  def request_consent_by_text(phone_number) 
    click(PHONE_NUMBER_RADIO_BTN)
    10.times { delete_char(PHONE_NUMBER_INPUT_FIELD) }
    enter(phone_number, PHONE_NUMBER_INPUT_FIELD) 
    click(PHONE_NUMBER_SUBMIT_BTN)
  end

  def scroll_down_consent(selector) # needs debugging on firefox
    consent_box = find(selector)

    # can't use js commands on this iframe - it throws a security error 
    # increased initial scroll downs from 5 to 30 to work w chrome
    for i in 0..30 # chrome is giving a hard time with scrolling
      consent_box.send_keys :page_down
    end

    sleep(1) # wait for animation
  end 

end
